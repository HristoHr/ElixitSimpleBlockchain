defmodule Wallet do

  defstruct [
  publicKey: "",
  privateKey: "",
  ]
def init()do
  {publicKey,privateKey}  = :crypto.generate_key(:ecdh, :secp256k1, :crypto.strong_rand_bytes(16))
  wallet = %Wallet{
  publicKey: publicKey,
  privateKey: privateKey
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
