defmodule Test do
  def fib(n) do
    cond do
      n == 1 -> 1
      n == 2 -> 1
      n -> fib(n-1) + fib(n-2)
    end
  end

  def paralfib() do
    from = self()
    receive do
      {:ok, from, x} ->
	IO.puts("did it parallel1")
	send(from, fib(x))
      end
  end

  def test() do
    from = self()
    fib1 = spawn(fn() -> paralfib() end)
    fib2 = spawn(fn() -> paralfib() end)
    send(fib1, {:ok, from, 6})
    send(fib2, {:ok, from, 10})
    IO.puts("got here")
    t = 1
    if t == 1 do
    receive do
      x -> IO.puts("#{x}")
      end
    end
    receive do
      x -> IO.puts("#{x}")
    end
  end
end
