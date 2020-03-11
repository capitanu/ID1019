defmodule Btree do
  def member(element, :nil) do :no end
  
  def member(element, {:leaf, element}) do :yes end
  def member(element, {:leaf, _}) do :no end

  def member(element, {:node, element, left, right}) do :yes end
  def member(element, {:node, x , left, right}) do
    if element < x and left == :nil do :no end
    if element > x and right == :nil do :no end
    if element < x do member(element, left)
    else member(element, right) end
  end

  def insert(element, :nil) do {:leaf, element} end
  
  def insert(element, {:leaf, value}) do
    if element < value do {:node, value, {:leaf, element}, :nil}
    else {:node, value, :nil, {:leaf, element}} end
  end

  def insert(element, {:node, value, left, right}) do
    if element < value do {:node, value,insert(element, left), right}
    else {:node, value, left, insert(element, right)} end
  end

  def delete(element, {:leaf, element}) do :nil end
  def delete(element, :nil) do :nil end

  def delete(element, {:node, element, :nil, right}) do right end
  def delete(element, {:node, element, left, :nil}) do left end

   def delete(element, {:node, element, left, right}) do
    {:node, rightmost(left), delete(rightmost(left), left), right} end


  def delete(element, {:node, value, left, right}) do
    if element < value do if delete(element,left) == :nil and right == :nil do {:leaf, value}
    else{:node, value,delete(element, left), right} end
    else if delete(element,right) == :nil and left == :nil do {:leaf,value}
    else{:node, value, left, delete(element, right)} end end
  end

  def delete(element, {:node, element, left, right}) do
    {:node, rightmost(left), delete(rightmost(left), left), right} end

  def rightmost({:leaf, element}) do element end
  def rightmost({:node, _, _, right}) do rightmost(right) end
end

defmodule KeyValue do
    def lookup(key, :nil) do :no end
    def lookup(key, {:node, key, value, left, right}) do {:ok, value} end
    def lookup(key, {:node, key1, _ , left, right}) do
      if key < key1 do lookup(key, left)
      else lookup(key, right) end
    end

    def remove(key, {:node, key, value, :nil, right}) do right end
    def remove(key, {:node, key, value, left, :nil}) do left end
    def remove(key, {:node, key, value, left, right}) do
      {:node, rightmost(left), lookup(rightmost(left),left), remove(rightmost(left),left), right} end
    def remove(key, {:node, key1, value1 , left, right}) do
      if key < key1 do {:node, key1, value1, remove(key, left), right}
      else {:node, key1, value1, left, remove(key,right)} end
    end

    def rightmost({:node, key, value, left, :nil}) do key end
    def rightmost({:node, key, value, left, right}) do rightmost(right) end

    def add(key, value, :nil) do {:node, key, value, :nil, :nil} end
    def add(key, value, {:node, key1, value1 , left, right}) do
      if key < key1 do {:node,key1, value1, add(key, value, left), right}
      else {:node, key1, value1 , left, add(key, value, right)} end
    end
    
    
    
end
