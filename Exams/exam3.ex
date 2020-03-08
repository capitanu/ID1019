defmodule Exam3 do
  def sum(:nil) do 0 end
  def sum({:node, val, left, right }) do
    val + sum(left) + sum(right)
  end

  def reverse([]) do [] end
  def tailreverse([elem | []] , t) do [elem | t] end
  def tailreverse([elem | list], t) do
      tailreverse(list, [elem | t])
  end
  def reverse(n) do
    tailreverse(n, [])
  end

  def append([],list2) do list2 end
  def tailappend([], list2) do list2 end
  def tailappend([elem | rest], list2) do
    tailappend(rest, [elem | list2]) end
  def append(list1, list2) do
      list1 = reverse(list1)
      tailappend(list1, list2)
  end  
end

defmodule Sum do
  def sum(tree) do
    self = self()
    spawn(fn() -> sum(self, tree) end)
    receive do
      x -> x
    end
  end
  def sum(x, {:node, left, right}) do
    self = self()
    lefttree = spawn(fn() -> sum(self,left) end)
    righttree = spawn(fn() -> sum(self,right) end)
    sum1 = receive do x -> x end
    sum2 = receive do x ->  x end
    send(x, sum1+sum2)
    sum1+sum2
  end
  def sum(from,{:leaf, value}) do
    send(from, value)
  end  
end

defmodule Heap do

  def new() do {:heap,:nil ,:nil, :nil} end

  def add(:nil, x) do {:heap, x, :nil, :nil} end
  def add({:heap, :nil, x, y}, val) do {:heap,val, x,y} end
  def add({:heal, val, :nil, :nil}, valadd) do
    if valadd > val do
      {:heap, valadd, {:heap, val, :nil, :nil}}
    else {:heap, val, {:heap, valadd, :nil, :nil}, :nil} end
  end
  def add({:heap, val, :nil , y}, valadd) do
    if valadd > val do
      {:heap, valadd, {:heap, val, :nil,:nil},y}
    else {:heap, val, {:heap,valadd,:nil,:nil},y} end
  end
  def add({:heap,val,x, y}, valadd) do
    if valadd > val do
      {:heap, valadd, {:heap,val, x, :nil}, y}
    else {:heap, val,  y, add(x, valadd)}end
  end      
  
  
  
end
