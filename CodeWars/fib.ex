defmodule Fib do
  
  def fib(n) do
    if n >= 1 and n < 3 do 1
    else
      if n >=1 and n >=3 do posfib(n, 2, 1, 1)
      else
	if n <= 0 do
	  negfib(n, 2, 1, 1)
	end
      end
    end
  end
  def posfib(n, count, s1, s2) do
    if n == count+1 do s1+s2
		  else
		    if n > count*2 do
		      logfib(n, count, s1,s2)
		      else
		    if n- count < 100000 do
			  posfib(n,count,s1,s2,7)
			  else posfib(n,count,s1,s2,1000) end end
    end
  end
  def logfib(n,count, s1, s2) do
    posfib(n, count*2-1, s1*(2*s2 - s1), s2*s2+s1*s1)
  end
    
  def doit(i) do
    from = self()
    fib1 = spawn(fn() -> paralfib() end)
    fib2 = spawn(fn() -> paralfib() end)
    fib3 = spawn(fn() -> paralfib() end)
    send(fib1, {:ok, from, i-1})
    send(fib2, {:ok, from, i})
    send(fib3, {:ok, from, i+1})
    #IO.puts("#{i1}, #{i}, #{i2}")
    #receive do
    # {x1, i1}->
    #receive do {x2,i} ->
    #receive do {x3, i2} -> {x1,x2,x3}  end end end
    test1 = receive do {x, _} -> x end
    test2 = receive do {x, _} -> x end
    test3 = receive do {x, _} -> x end
    list = [test1, test2, test3]
    list = Enum.sort(list)
  end
  
  def posfib(n, count, s1, s2, i) do
    cond do
      i == 1 -> if n > count + i do posfib(n,count+1,s2, s1+s2) else posfib(n,count,s1,s2,i-1) end
      i == 2 -> if n > count + i do posfib(n,count+2,s1+s2, s1+2*s2) else posfib(n,count,s1,s2,i-1) end
      i >= 3 -> if n > count + i do
			       #IO.puts("#{i}")
			       [f1, f2, f3] = doit(i)
			       #IO.puts("#{f1} , #{f2}, #{f3} TEEEST")
			       posfib(n, count+i,f1*s1+f2*s2,f2*s1+f3*s2) else posfib(n,count,s1,s2,i-1) end
    end
  end
  def negfib(n, count, s1, s2) do
    if -n == count-2 do
		    s2 - s1
		   else
		     negfib(n, count+1, s2-s1, s1)
    end  
  end
  def bench(n) do
    start = Time.utc_now()
    test =  fiber(n)
    finish = Time.utc_now()
    diff = Time.diff(finish, start, :millisecond)
    IO.puts("To calculate fibonacci of #{n}, it took #{diff} miliseconds")
  end

  def parbench(n) do
    start = Time.utc_now()
    [f1,f2,f3] =  doit(n)
    IO.puts("#{f1} , #{f2}, #{f3}")
    finish = Time.utc_now()
    diff = Time.diff(finish, start, :millisecond)
    IO.puts("To calculate fibonacci of #{n}, it took #{diff} miliseconds")
  end


  def paralfib() do
    from = self()
    receive do
      {:ok, from, x} ->
	#IO.puts("#{x}, #{fib(x)}")
	send(from, {fib(x), x})
    end
  end
  require Integer
  def fiber(n) do
    cond do
      n<0 and Integer.is_even(n) -> -fib_iter(1, 0, 0, 1, -n)
      n<0 and Integer.is_odd(n) -> fib_iter(1, 0, 0, 1, -n)
      true -> fib_iter(1, 0, 0, 1, n)
    end
  end
  def fib_iter(a, b, p, q, count) do
    cond do
      count == 0 -> b
      Integer.is_even(count) -> fib_iter(a, b, (p*p)+(q*q), q*q+(2*p*q), div(count,2))
      true -> fib_iter((a*q+b*q+a*p), (b*p+a*q), p, q, count-1)
    end
  end
end
#-8 5 -3 2 -1 1 0 *1* 1 2 3
