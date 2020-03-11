defmodule Bitonic do
  def comp(low, high) do spawn(fn() -> comp(0, low, high) end)  end

  def comp(n, low, high) do
    receive do    {:done, ^n} ->
	send(low, {:done, n})   
	send(high, {:done, n})
      {:epoc, ^n, x1} ->
	receive do
          {:epoc, ^n, x2} ->
            if x1 < x2 do
              send(low,  {:epoc, n, x1})
              send(high, {:epoc, n, x2})
            else
              send(low, {:epoc, n, x2})
              send(high,{:epoc, n, x1})
            end
            comp(n+1, low, high)
	end
    end
  end
end
