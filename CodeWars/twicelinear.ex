defmodule Twice do

  def dbl_linear(n) do
    map = %{0 => 1}
    cond do
      n == 0 -> 1
      n -> dbl_linear(n, map, 0, 0, 1)
    end
  end

  def dbl_linear(0, map, _, _, count) do map[count-1] end
  def dbl_linear(n, map, s1, s2, count) do
    {:ok, x1} = Map.fetch(map, s1)
    {:ok, x2} = Map.fetch(map, s2)
    if 2*x1 < 3*x2 do
				   map = Map.put_new(map, count, 2*x1 + 1)
				   dbl_linear(n-1, map, s1+1, s2, count+1)
				   else if 2*x1 > 3*x2 do
     map = Map.put_new(map, count, 3*x2+1)
     dbl_linear(n-1, map, s1, s2+1, count+1)
     else 
      map = Map.put_new(map,count, 2*x1 + 1)
      dbl_linear(n-1, map, s1+1, s2+1, count+1)
    end
    end
    
  end
end
