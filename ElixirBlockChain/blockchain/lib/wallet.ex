defmodule Wallet do

  defstruct [
  publicKey: "",
  privateKey: "",
  #transactionsFrom: [],
  #transactionsTo: [],
  #balance: 0
  ]
def init()do
  {publicKey,privateKey}  = :crypto.generate_key(:ecdh, :secp256k1, :crypto.strong_rand_bytes(16))
  wallet = %Wallet{
  publicKey: publicKey, #|> Base.encode16(),
  privateKey: privateKey, #|> Base.encode16(),
  #transactionsFrom: [],
  #transactionsTo: [],
  #balance: 100 #<---for testing
  }
  Legger.add(publicKey)
  wallet
end

def signTransaction(privateKey,data)do
  :crypto.sign(:ecdsa, :sha256, data, [privateKey, :secp256k1]) #|> Base.encode16()
end

def verifySignature(pubicKey,data,signature)do
    :crypto.verify(:ecdsa, :sha256, data, signature,[pubicKey, :secp256k1])
end

end
