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

defmodule OWT do
  @type city() :: atom()
  @type dist() :: integer() | :inf

  @spec shortest(city(),city(),map()) :: dist()

  def shortest(from,to,map) do
    umap = Map.new([{to, 0}])
    dist = check(from, to, umap ,map)
    dist
  end

  @spec check(city(),city(),map(),map()) :: {:found, dist(),map()}

  def check(from,to,umap,map) do
    temp = Map.get(umap,from, :nil)
    case temp do
      :nil -> shortest(from,to,umap,map)
      distance -> {:found,temp,umap}
	#select(temp, to, umap, map)
    end
  end

  @spec shortest(city(),city(),map(),map()) :: {:found,dist(),map()}

  def shortest(from,to,umap,map) do
    umap = Map.put(umap,to,:inf)
    neighbours = Map.get(map, to)
    {:found, dist, umap} = select(neighbours, to, umap,map)
    IO.puts("DIST: #{dist}, FROM: #{from}, TO: #{to}")
    #...
    {:found, dist, umap}
  end

  @spec select([{:city,city(),integer()}], city(),map(),map()) :: {:found,dist(),map()}

  def select([], _, umap,map) do {:found, :inf, map} end
  def select([{:city,next,d1} | rest], to, umap, map) do
    {:found, d2, umap}= check(next,to,Map.put(umap,next, d1),map)
    dist = add(d1,d2)
    {found, sele, _} = select(rest,to,umap,map)
    if sele < dist do
      {:found, sele, umap}
    else
      {:found,dist,umap}
    end
  end

  @spec add(dist(),dist()) :: dist()

  def add(:inf, _) do :inf end
  def add(_, :inf) do :inf end
  def add(x, y) do x+y end
end

#map = Map.new([{:a, [{:city, :b, 5},{:city,:c,3}]}, {:b, [{:city, :a,5},{:city,:c,1},{:city,:d,2}]},{:c,[{:city,:a,3},{:city,:b,1}]},{:d,[{:city,:b,2}]}])
#map = Map.new([{:a, [{:city,:b,1}]}, {:b, [{:city, :a, 1}, {:city, :c, 2}]}, {:c, [{:city,:b,2}]}])
