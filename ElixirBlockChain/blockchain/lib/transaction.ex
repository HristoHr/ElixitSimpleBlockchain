defmodule Transaction do

  defstruct [
  fromPubKey: "",
  toPubKey: "",
  amount: "",
  data: "",
  hash: "",
  signature: ""
  ]
  def init(fromPubKey,fromPrKey,toPubKey,amount) do
    data = getTransactionData(fromPubKey,toPubKey,amount)
    hash = getTransactionHash(data)
    signature = getTransactionSignature(fromPrKey,data)
    %Transaction{
      fromPubKey: fromPubKey,
      toPubKey: toPubKey,
      amount: amount,
      data: data,
      hash: hash,
      signature: signature
    }
  end

  def getTransactionData(fromPubKey,toPubKey,amount)do
    Enum.join([fromPubKey,toPubKey,amount], " ")
  end

  def getTransactionHash(data)do
    :crypto.hash(:sha256, data)
  end

  def getTransactionSignature(fromPrKey,data)do
    Wallet.signTransaction(fromPrKey,data)
  end

  def verifyTransaction(tx)do
    (Legger.getBalance(tx.fromPubKey))>=(tx.amount)
    &&
    Wallet.verifySignature(tx.fromPubKey,tx.data,tx.signature)
  end

end
