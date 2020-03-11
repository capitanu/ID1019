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
		    if n- count < 100000 do
			  posfib(n,count,s1,s2,7)
			  else posfib(n,count,s1,s2,1000) end
    end
  end
  def doit(i) do
    from = self()
    fib1 = spawn(fn() -> paralfib() end)
    fib2 = spawn(fn() -> paralfib() end)
    fib3 = spawn(fn() -> paralfib() end)
    send(fib1, {:ok, from, i-1})
    send(fib2, {:ok, from, i})
    send(fib3, {:ok, from, i+1})
    i1 = i-1
    i2 = i+1
   # receive do
  #    {x1, i1}->
#	receive do {x2,i} ->
#	    receive do {x3, i2} -> {x1,x2,x3}  end end end
    test1 = receive do {x, i1} -> x end
    test2 = receive do {x, i} -> x end
    test3 = receive do {x, i2} -> x end
    test = {test1,test2,test3}
  end
  
  def posfib(n, count, s1, s2, i) do
    cond do
      i == 1 -> if n > count + i do posfib(n,count+1,s2, s1+s2) else posfib(n,count,s1,s2,i-1) end
      i == 2 -> if n > count + i do posfib(n,count+2,s1+s2, s1+2*s2) else posfib(n,count,s1,s2,i-1) end
      i >= 3 -> if n > count + i do
			       
			       {f1, f2, f3} = doit(i)
			       #IO.puts("#{f1} , #{f2}, #{f3}")
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
    test =  fib(n)
    finish = Time.utc_now()
    diff = Time.diff(finish, start, :millisecond)
    IO.puts("To calculate fibonacci of #{n}, it took #{diff} miliseconds")
  end

  def paralfib() do
    from = self()
    receive do
      {:ok, from, x} ->
	send(from, {fib(x), x})
    end
  end
end
#-8 5 -3 2 -1 1 0 *1* 1 2 3
