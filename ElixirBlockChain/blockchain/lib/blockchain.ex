defmodule Blockchain do
   use GenServer

  def init() do
    start_link()
  end

  def getLastBlock()do
    GenServer.call(__MODULE__,:getLastBlock)
  end

  def getAllBlocks()do
    GenServer.call(__MODULE__,:getAllBlocks)
  end

  def addBlock()do
    GenServer.cast(__MODULE__,:addBlock)
  end

  def start_link() do
     GenServer.start_link(__MODULE__,[Block.init("","")], name: __MODULE__)
  end

  def handle_call(:getLastBlock, _from, blockchain) do
    [lastBlock | _ ] = blockchain
    {:reply, lastBlock, blockchain}
  end

  def handle_call(:getAllBlocks,_from, blockchain) do
    {:reply, blockchain, blockchain}
  end

  def handle_cast(:addBlock, blockchain) do
    [lastBlock | _ ] = blockchain
    rootHash = calculate_root_hash(TransactionPool.getAll())
    newBlock = Block.init(rootHash, lastBlock.hash)
    if(Block.verifyBlock(newBlock.hash,lastBlock.hash,rootHash,newBlock.nonce))do
      {:noreply, [newBlock | blockchain]}
    else
      {:error}
    end
  end

  def calculate_root_hash(txs)  do
    txs
    |> build_merkle_tree()
    |> :gb_merkle_trees.root_hash()
  end

  def build_merkle_tree(txs) do
    if Enum.empty?(txs) do
      <<0::256>>
    else
      merkle_tree =
      for transaction <- txs do
        {:crypto.hash(:sha256, transaction.data), transaction.data}
      end

      merkle_tree
      |> List.foldl(:gb_merkle_trees.empty(), fn node, merkle_tree ->
        :gb_merkle_trees.enter(elem(node, 0), elem(node, 1), merkle_tree)
      end)
    end
  end

end

# Start the server
#{:ok, pid} = GenServer.start_link(Stack, [:hello])

# This is the client
#GenServer.call(pid, :pop)
#=> :hello
#GenServer.cast(pid, {:push, :world})
#=> :ok
#GenServer.call(pid, :pop)
#=> :world
