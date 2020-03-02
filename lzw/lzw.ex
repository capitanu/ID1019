defmodule LZW do

  @alphabet 'abcdefghijklmnopqrstuvwxyz '

  def test(), do: test('this is a test to see if it works')

  def test(text) do
    IO.puts("The string of text: #{text}\n")
    IO.puts("The plain string as charlist:")
    IO.inspect(text, charlists: :as_lists)

    encoded = encode(text)
    IO.puts("\nThe encoded string as charlist:")
    IO.inspect(encoded)

    IO.puts("\nLength of text: #{length(text)}")
    IO.puts("Length of encoded: #{length(encoded)}\n")

    string_text = to_string(text)
    case to_string(decode(encoded)) do
      ^string_text ->
        IO.puts("SUCCESS: The decoded message matches the original string!\n")
      _ ->
        IO.puts("ERROR: The decoded message does NOT match the original string!\n")
    end
  end
  def table() do
    n = length(@alphabet)
    numbers = Enum.to_list(1..n)
    map = List.zip([@alphabet, numbers])
    {n + 1, map}
  end

  def encode([]), do: []

  def encode([word | rest]) do
    table = table()
    {:found, code} = encode_word(word, table)
    encode(rest, word, code, table)
  end

  def encode([], _sofar, code, _table), do: [code]

  def encode([word | rest], sofar, code, table) do
    extended = [word | sofar]
    case encode_word(extended, table) do
      {:found, ext} ->
	encode(rest, extended, ext, table);
      {:notfound, updated} ->
	{:found, cd} = encode_word(word, table)
	[code | encode(rest, [word], cd, updated)]
    end
  end

  def encode_word(word, {nr, map}) do
    case List.keyfind(map, word, 0) do
      {_word, code} -> {:found, code}
      nil -> {:notfound, {nr+1, [{word, nr} | map]}}
    end
  end

  def decode(codes) do
    table = table()
    decode(codes, table)
  end

  def decode([], table) do [] end
  def decode([code | []], {n, map}) do
    {word, _code} = List.keyfind(map,code, 1)
    word
  end

  def decode([code | rest], {n, map}) do
    {word, _} = List.keyfind(map, code, 1)
    [next | _ ] = rest

    next_char =
      case List.keyfind(map, next, 1) do
	{char, _} ->
	  case is_list(char) do
	    true -> List.first(char)
	    false -> char
	  end

	nil ->
	  IO.puts("Could not find #{next}")
	  [char | _] = word
	  char
      end

    [word] ++ [decode(rest, {n + 1, [{[word] ++ [next_char] , n} | map]})]
  end
  
  
end

