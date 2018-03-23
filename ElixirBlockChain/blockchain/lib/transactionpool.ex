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

@doc"""
  Returns all the transactions from the pool and empries the pool
"""
def handle_call(:getAll, _from, transactionPool) do
    {:reply,transactionPool, []}
end

@doc"""
  Adds transaction to the pool
  1 Check if transaction is valid
    a.) If the transaction is valid adds it to the pool
    b.) If the transaction is not valid returns invalid :invalid_transaction_error
"""
def handle_call({:addTx, tx},_from, transactionPool) do
  #Verify transaction
  if(!Transaction.verifyTransaction(tx))do
    {:reply, :invalid_transaction_error, transactionPool}
  else
    Legger.edit(tx.fromPubKey,tx.toPubKey,tx.amount)
    {:reply,:ok, [tx | transactionPool]}
  end
end

end
