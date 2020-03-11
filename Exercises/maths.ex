defmodule Calculator do
  defmodule Multiplication do
    def multiplication(a,0) do
      0
    end
    
    def multiplication(a,b) do
      if b < 0 and a > 0 do
	multiplication(b, a)
      else
	if b < 0 and a < 0 do
	  multiplication(a * -1, b * -1)
	else
	  a + multiplication(a, b - 1)
	end
      end
    end    
  end
  #Comment
  defmodule Power do
    def power(a, 0) do
      1
    end

    def power(a, b) do
      Multiplication.multiplication(power(a,b-1), a)
    end

    def qpower(a,b) do
      cond do
	b == 0 -> 1
	rem(b,2) == 1 -> a * qpower(a, b-1)
	rem(b,2) == 0 -> qpower(Multiplication.multiplication(a,a), div(b,2))
	
      end
    end
  end
end

defmodule Fibonacci do
  def fib(n) do
    case n do
      0 -> 0
      1 -> 1
      n -> fib(n-1) + fib(n-2)
    end
  end
end

defmodule Ackermann do
  def ack(0,n) do
    n+ 1
  end
  def ack(m,n) do
    if n == 0 and m > 0 do ack(m-1, 1)
    else ack(m-1,ack(m,n-1))
    end
  end
end





