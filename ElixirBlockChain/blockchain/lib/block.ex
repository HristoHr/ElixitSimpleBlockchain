defmodule Block do

  defstruct [
  rootHash: "",
  prevHash: "",
  hash: "",
  nonce: 0
  ]

  def init(rootHash,prevHash) do
    #Maybe I should not be doing this with strings
    {:ok,hash,nonce} = mineBlock(prevHash,rootHash,4)
    %Block{
    rootHash: rootHash,
    prevHash: prevHash,
    hash: hash,
    nonce: nonce
    }
  end

  def mineBlock(prevHash,rootHash,difficulty\\4)do
    difficulty = difficultyStr(difficulty)
    mineLoop(0,prevHash,rootHash,difficulty,false)
  end

  def mineLoop(nonce,currentHash,_,_,true) do
     {:ok,currentHash,nonce}
   end
  def mineLoop(nonce,prevHash,rootHash,difficulty,false) do
    currentHash = :crypto.hash(:sha256, Enum.join([prevHash,rootHash,nonce], ""))
    currentHash16 = currentHash|> Base.encode16()
    if(String.slice(currentHash16,0..(String.length(difficulty)-1))!=difficulty) do
      #IO.puts "currentHash : #{currentHash}"
      #IO.puts "nonce : #{nonce}"
      nonce=nonce+1
      mineLoop(nonce,prevHash,rootHash,difficulty,false)
    else
      mineLoop(nonce,currentHash,rootHash,difficulty,true)
    end
  end

  def difficultyStr(dif) do
    difficultyLoop(dif,0,"")
  end

  def difficultyLoop(0,_,str) do
    str
  end

  def difficultyLoop(max,min,str) do
    if max < min do
      difficultyLoop(0, min,str)
    else
      str = Enum.join([str,"0"], "")
      difficultyLoop(max - 1, min,str)
    end
  end

  def verifyBlock(currentHash,prevHash,rootHash,nonce)do
    targetHash= :crypto.hash(:sha256, Enum.join([prevHash,rootHash,nonce], ""))
    (currentHash==targetHash)
  end

end
