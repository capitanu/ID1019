defmodule Exam do
  def drop([], n) do [] end
  def drop(list,n ) do drop(list, n, 1) end
  def drop([], n, i) do [] end
  def drop([elem | rest], n, i) do
    if rem(i,n) == 0 do drop(rest,n,i+1)
    else [elem | drop(rest, n , i+1)]
    end
  end

  def nth(n, {:node, left, right}) do
    {a,b} = nth(n, left)
    if a == :found do {a,b}
    else nth(b, right)
    end
  end
  def nth(1,{:leaf, val}) do {:found, val} end
  def nth(n,{:leaf, val}) do {:cont, n-1} end

  def pascal(n) do
    cond do
      n == 1 -> [1]
      n == 2 -> [1,1]
      n -> pascal(n-2, [1,1])
    end
  end

  def pascal(0, list) do list end
  def pascal(n, list) do pascal(n-1, [1 |get(list)]) end
  def get([s1]) do [s1] end
  def get([]) do [] end
  def get([s1,s2 | rest]) do [s1+s2 | get([s2 | rest])] end
end
