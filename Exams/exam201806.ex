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
end
