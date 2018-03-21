defmodule TransactionPool do
  use GenServer

def init() do
  start_link()
end

def addTransaction(tx) do
    GenServer.call(__MODULE__, {:addTx, tx})
end

def getAll do
  GenServer.call(__MODULE__, :getAll)
end

def start_link do
  GenServer.start_link(__MODULE__,[], name: __MODULE__)
end

def handle_call(:getAll, _from, transactionPool) do
   # {:reply,transactionPool, []}
   {:reply,transactionPool, transactionPool} #<---for testing
end

def handle_call({:addTx, tx},_from, transactionPool) do
  ##Ferify signature
  if(Transaction.verifyTransaction(tx))do
    Legger.edit(tx.fromPubKey,tx.toPubKey,tx.amount)
    {:reply,:ok,[tx | transactionPool]}
  else
    {:error}
  end
end

end
