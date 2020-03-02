defmodule Lambda do
  def fib(y) do
    fib = fn(x, f) ->
      case x do
	1 -> 1
	2 -> 1
	x -> f.(x-1, f) + f.(x-2, f)
      end
    end
    fib.(y, fib)	
  end
  
  def fact(n) do
    f = fn(n, f) -> if n == 0 do 1 else n * f.(n-1, f) end end
    f.(n,f)
  end
end
