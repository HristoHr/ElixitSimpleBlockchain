defmodule Legger do
  use GenServer

  def init do
    start_link()
  end

  def getAll do
    GenServer.call(__MODULE__, :getLegger)
  end

  def getBalance(pubKey) do
    GenServer.call(__MODULE__, {:getBalance,pubKey})
  end

  def add(pubKey) do
      GenServer.call(__MODULE__, {:add, pubKey})
  end

  def edit(fromPubKey,toPubKey, amount) do
      GenServer.call(__MODULE__, {:edit,fromPubKey,toPubKey,amount})
  end

  def start_link do
    GenServer.start_link(__MODULE__,%{}, name: __MODULE__)
  end

  def handle_call(:getLegger, _from, legger) do
     {:reply,legger, legger}
  end

  def handle_call({:getBalance,pubKey}, _from, legger) do
      balance = Map.get(legger,pubKey)
     {:reply,balance, legger}
  end

  @doc"""
    Adds new wallet to the Legger.
    This method is called as soon as a Wallet is created.
  """
  def handle_call({:add,pubKey}, _from, legger) do
    legger =  Map.put_new(legger, pubKey, 100) #<---Initial balance starts at 100 for testing
    {:reply,legger, legger}
  end

  @doc"""
    Edit's balance of 2 wallets in a transaction.
    Substracts the amount from the sending address
    and adds it to the recieiving one.
  """
  def handle_call({:edit,fromPubKey,toPubKey,amount}, _from, legger) do
    newBalanceFrom = Map.get(legger,fromPubKey)-amount
    newBalanceTo = Map.get(legger,toPubKey)+amount
    legger= Map.replace!(legger,fromPubKey,newBalanceFrom)
    legger= Map.replace!(legger,toPubKey,newBalanceTo)
    {:reply,legger, legger}
  end

end
