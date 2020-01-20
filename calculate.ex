defmodule Calc do
  def eval({:int, n}) do n end
  def eval({:add, a, b}) do eval(a) + eval(b) end
  def eval({:sub, a, b}) do eval(a) - eval(b) end
  def eval({:mul, a, b}) do eval(a) * eval(b) end


  def lookup(var, [{:bind, var, value} | _] ) do {:int, value} end
  def lookup(var, [_ | rest]) do lookup(var,rest) end

  def eval({:var,name}, bindings) do lookup(name,bindings) end
  def eval({:add, x, y}, bindings) do eval({:add, eval(x, bindings), eval(y, bindings)}) end
  def eval({:sub, x, y}, bindings) do eval({:sub, eval(x, bindings), eval(y, bindings)}) end
    def eval({:mul, x, y}, bindings) do eval({:mul, eval(x, bindings), eval(y, bindings)}) end

  
end
