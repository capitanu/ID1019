defmodule Exam4 do
  def fizzbuzz(n) do
    fizzbuzz(1,n+1,1,1) 
  end
  def fizzbuzz(1,n,three,five) do fizzbuzz(1,n,three,five, []) end
  def fizzbuzz(elem, 1, _, _, list) do reverse(list) end
  def fizzbuzz(elem, n, 3, 5, list) do
    fizzbuzz(elem+1, n-1,1,1,[:fizzbuzz | list]) end
  def fizzbuzz(elem, n,3,five,list) do
    fizzbuzz(elem+1,n-1,1,five+1,[:fizz | list]) end
  def fizzbuzz(elem,n,three,5,list) do
    fizzbuzz(elem+1,n-1,three+1,1,[:buzz  | list]) end
  def fizzbuzz(elem, n, three, five, list) do
    fizzbuzz(elem+1,n-1,three+1,five+1, [elem | list]) end

  
  def reverse(list) do nreverse(list,[]) end
  def nreverse([],list) do list end
  def nreverse([elem | rest], list) do
    nreverse(rest,[elem|list])
  end
  def nappend([], list) do list end
  def nappend([elem| rest], list2) do
    nappend(rest, [elem | list2])
  end
  def append(list1, list2) do
    nappend(reverse(list1), list2)
  end

  def fairly(:nil) do :nil end
  def fairly({:node,:nil,:nil}) do {:ok,1} end
  def fairly({:node,:nil,right}) do
    {x,y} = fairly(right)
    if y >= 2 do :no else
      {:ok, 1+y} end
  end
  def fairly({:node,left,:nil}) do
    {x,y} = fairly(left)
    if y >= 2 do :no else
      {:ok, 1+y} end
  end
  
  def fairly({:node, left, right}) do
    {msg, x} = fairly(left)
    {msg1, y} = fairly(right)
    if msg == :no or msg1 == :no do :no
    else if abs(x-y) > 1 do :no
    else {:ok,1 + max(x,y)} end end
  end

  def dillinger() do
    spawn(fn() -> nyc() end)
  end
  def nyc() do
    IO.puts("Hey Jim!")
    receive do
      :knife -> knife()
    end
  end

  def knife() do
    receive do
      :fork -> fork()
    end
  end
  
  def fork() do
    receive do
      :bottle -> bottle()
    end
  end
  def bottle() do
    receive do
      :cork -> nyc()
    end
  end

  def calc() do 3 end
  def test() do
    spawn(calc())
  end
    
end
