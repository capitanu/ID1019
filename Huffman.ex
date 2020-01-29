defmodule Huffman do

  def sample() do
   'the quick brown fox jumps over the lazy dog this is a sample text that we will use when we build u a table we will only handle lower case letters and no punctuation symbols the frequency will of course not represent english but it is probably not that far off'
   # 'testing'
  end

  def text()  do
    'this is something that we should encode'
    #'esteg'
  end

  def test() do
    sample = read("Huffman.ex")
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    {x, tree} =  huffman(freq)
    tree
  end

  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq) do
    qsort(freq)
  end

  def freq([char | rest], freq) do
    freq(rest, add(char, freq))
  end

  def huffman([{number, tree}]) do tree end
  def huffman([{freq1, char1} ,  {freq2, char2}]) do {freq1+ freq2, {char1, char2}} end
  def huffman([x | rest]) do  huffman(qsort([x | [huffman(rest)]])) end


  
  def add(char, []) do [{1, char}] end
  def add(char, [{x, char} | rest]) do [{x+1, char} | rest] end
  def add(char, [{x, notchar} | rest]) do [{x, notchar} |add(char, rest)] end
  def add(char, [{x, notchar} | []]) do [{x, notchar} | add(char, [])] end

  def qsort([]) do [] end
  def qsort([p | l]) do 
    {half1, half2} = qsplit(p, l, [], [])
    small = qsort(half1)
    large = qsort(half2)
    append(small, [p | large])
  end


  def qsplit(_, [], small, large) do {small, large} end
  def qsplit({p, c1}, [{h, c2} | t], small, large) do
    if h >= p  do
      qsplit({p, c1} ,t,[{h, c2} | small],large)
    else
      qsplit({p, c1},t,small, [{h, c2} | large])
    end
  end

  def append(half1, half2) do
    case half1 do
      [] -> half2
      [h | t] -> [h | append(t, half2)]
    end
  end

  
  
  def encode_table({subtree, value}, sofar) do
    [{value, reverse([1 | sofar])} | encode_table(subtree, [0 | sofar])] end
  def encode_table({subtree, value}) do
    [{value, [1]} | encode_table(subtree, [0])] end
  def encode_table(value, sofar) do
    [{value, sofar}] end

  def decode_table(tree) do
    encode_table(tree)
  end

  def encode([], smth) do [] end
  def encode([letter | tail], tree) do searchtree(letter, tree) ++ encode(tail, tree) end

  def searchtree(letter, [{letter, value} | rest]) do value end
  def searchtree(letter, [{letter1, _} | rest]) do searchtree(letter, rest) end

  def decode([], _)  do [] end
  def decode(seq, table) do
  {char, rest} = decode_char(seq, 1, table)
  [char | decode(rest, table)]
end

def decode_char(seq, n, table) do
  {code, rest} = Enum.split(seq, n)
  case List.keyfind(table, code, 1) do
    {char, value} -> {char, rest}
    nil -> decode_char(seq, n+1, table)
  end
end

  def reverse([]) do [] end
  def reverse([h | t]) do
    reverse(t) ++ [h]
  end
  def reverse(int) do [int] end

  
def read(file) do
  {:ok, file} = File.open(file, [:read])
  binary = IO.read(file, :all)
  File.close(file)

  case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, list, _} ->
      list;
    list ->
      list
  end
end    
  
end
