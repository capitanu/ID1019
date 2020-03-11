defmodule PokerHand do
  @result %{win: 1, loss: 2, tie: 3}
  
  def compare(player, opponent) do
    playerstring = String.codepoints(player)
    opponentstring = String.codepoints(opponent)
    playerhand = parse(playerstring)
    opponenthand = parse(opponentstring)
  end

  def parse([first, second]) do
    <<t>> = first
    [{t,second}] end
  def parse([first, second, " " | rest]) do
    <<t>> = first
    [{t,second} | parse(rest)]
  end

  def rank(hand) do
  end
    
end
