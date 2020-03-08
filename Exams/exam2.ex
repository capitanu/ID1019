defmodule Fib do
  def fib() do
    fn() -> fib(1,0) end
  end
  def fib(x,y) do
    {:ok,x, fn() ->fib(y+x, x) end}
  end



  
  def take(fun,n) do
    {:ok, w, fun} = take(fun, n, [])
    {:ok, reverse(w), fun}
  end

  def take(fun, 0, w) do
    {:ok, w, fun}
  end
  def take(fun, n, w) do
    {:ok, y, fun} = fun.()
    {:ok, [y | w], fun} = take(fun, n-1, [y | w])
  end
  def reverse([]) do [] end
  def reverse([elem | rest]) do
    reverse(rest) ++ [elem]
  end
  
  
  def test() do
    cont = fib()
    {:ok, f1, cont} = cont.()
    {:ok, f2, cont} = cont.()
    {:ok, f3, cont} = cont.()
    [f1,f2,f3]
  end
end

defmodule Task do
  def start(user) do
    {:ok, pid} = {:ok, spawn(fn() -> proc(user) end)}
    send(pid,{:process, 7})
  end

  def proc(user) do
    receive do
      {:process, task} ->
        pid2 = spawn(fn() -> func() end)
        send(pid2, {:task, user, task})
      :quit ->
        :ok
    end
    proc(user)
  end

  def func() do
    receive do
      {:task, pid, task} ->
        done = doit(task)
	IO.puts("#{done}")
	send(pid, done)
    end
  end

  def doit(task) do
    task + 10
  end

end
