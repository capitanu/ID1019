defmodule Lists do
  def tak(n) do
    if is_list(n) and length(n) != 0 do
      [head | useless] = n
      head
    else
      :no
    end
  end

  def drp(n) do
    if is_list(n) and length(n) != 0 do
      [useless | tail] = n
      tail
    else
      :no
    end
  end

  def len(l) do
    if tak(l) != :no do
      1 + len(drp(l))
    else
      0
    end
  end

  def sum(l) do
    if tak(l) != :no do
      tak(l) + sum(drp(l))
    else
      0
    end
  end

  def duplicate(l) do
    if tak(l) != :no do
      [ tak(l), tak(l) | duplicate(drp(l))]
    else
      []
    end
  end


  
  def add(x, []) do [x] end
  def add(x, [x | tail]) do [x | tail] end
  def add(x, [head | tail]) do [head | add(x , tail)] end

  def remove(x, []) do [] end
  def remove(x, [x | tail]) do
    if drp(tail) != :no do
      remove(x, tail)
    else
      []
    end
    
  end
  
  def remove(x, [head | tail]) do [head | remove(x, tail)] end


  def unique([]) do [] end
  def unique(t) do
    if tak(t) != :no do
      if remove(tak(t),drp(t)) == drp(t) do
	[tak(t) | unique(drp(t))]
      else
	unique(remove(tak(t), t))
      end
    else
      []
    end
  end
  
  def append([], x) do x end
  def append([head | tail],y) do
    [head | append(tail,y)]
  end
  
  def nreverse([]) do [] end
  def nreverse([head | tail]) do append(reverse(tail), [head]) end

  def reverse(l) do
  reverse(l, [])
end

def reverse([], r) do r end
def reverse([h | t], r) do
  reverse(t, [h | r])
end
    
    def bench() do
  ls = [16, 32, 64, 128, 256, 512]
  n = 100
  # bench is a closure: a function with an environment.
  bench = fn(l) ->
    seq = Enum.to_list(1..l)
    tn = time(n, fn -> nreverse(seq) end)
    tr = time(n, fn -> reverse(seq) end)
    :io.format("length: ~10w  nrev: ~8w us    rev: ~8w us~n", [l, tn, tr])
  end

  # We use the library function Enum.each that will call
  # bench(l) for each element l in ls
  Enum.each(ls, bench)
end

# Time the execution time of the a function.
def time(n, fun) do
  start = System.monotonic_time(:milliseconds)
  loop(n, fun)
  stop = System.monotonic_time(:milliseconds)
  stop - start
end

# Apply the function n times.
def loop(n, fun) do
  if n == 0 do
    :ok
  else
    fun.()
    loop(n - 1, fun)
  end
end



  
end

