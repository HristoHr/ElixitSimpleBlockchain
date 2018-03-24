ElixitSimpleBlockchain..
Open terminal in blockchain folder type command iex -S mix
Init.initAll --> initializes Blockchain (automatically creates gen block) TransactionPool and Legger Gen Servers
Init.addTxs --> create a few wallets and add a few transactions
Legger.getAll --> returns all wallets and all balances
TransactionPool.getAll --> returns all transactions in the pool 
Blockchain.addBlock --> validate and add block to the chain
Blockchain.getAllBlocks --> returns all blocks


