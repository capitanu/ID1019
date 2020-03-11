defmodule Rev do
  def reverse([]) do [] end
  def reverse([elem | rest]) do
    nreverse([elem | rest], [])
  end
  def nreverse([], list) do list end
  def nreverse([elem| rest], list) do
    nreverse(rest, [elem | list])
  end

  def append(list1, list2) do
    nappend(reverse(list1), list2)
  end
  def nappend([], list) do list end  
  def nappend([elem | rest] , list) do
    nappend(rest, [elem | list])
  end

  def rotate(list, 0)  do list end
  def rotate([], _) do [] end
  def rotate(list, n) do
    rotate(list, [], n)
  end
  def rotate(list1, list2, 0) do append(list1, reverse(list2)) end
  def rotate([elem | rest], list2, n) do rotate(rest, [elem | list2], n-1) end
end
