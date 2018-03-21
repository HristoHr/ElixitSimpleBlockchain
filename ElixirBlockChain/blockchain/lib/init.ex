defmodule Init do

  def initAll do
    Blockchain.init
    Legger.init
    TransactionPool.init
  end

  def addTxs do
      walletA = Wallet.init()
      walletB = Wallet.init()
      walletC = Wallet.init()
      tx0 = Transaction.init(walletA.publicKey,walletA.privateKey,walletB.publicKey,10)
      tx1 = Transaction.init(walletC.publicKey,walletC.privateKey,walletB.publicKey,5)
      tx2 = Transaction.init(walletB.publicKey,walletB.privateKey,walletA.publicKey,12)
      tx3 = Transaction.init(walletA.publicKey,walletA.privateKey,walletC.publicKey,1)
      TransactionPool.addTransaction(tx0)
      TransactionPool.addTransaction(tx1)
      TransactionPool.addTransaction(tx2)
      TransactionPool.addTransaction(tx3)
  end
end
