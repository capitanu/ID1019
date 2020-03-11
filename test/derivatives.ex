defmodule Der do
  @type literal() :: {:const, number()} | {:const, atom()} | {:var, atom()}
  @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} | literal() | {:pwr, atom(), number()} | {:frac, literal(), literal()} | {:sub, expr(), expr()} | {:sqrt, expr()} | {:sin, expr()} | {:cos, expr()}

  def test() do
    test =
    {:add, {:add, {:mul, {:mul, {:const, 2}, {:var, :x}}, {:var, :x}}, {:mul, {:const,3}, {:var, :x}}}, {:const, 5}}
      print(deriv(test, :x))
  end

  def test2() do
    test2 = {:mul, {:const, 2}, {:var, :x}}
    print(deriv(test2, :x))
  end

  def test3() do
    test3 = {:add, {:mul, {:const, 4}, {:pwr, {:var, :x}, {:const, 2}}}, {:add, {:mul, {:const, 3}, {:var, :x}}, {:const, 42}}}
    print(deriv(test3, :x))
  end

  def deriv({:const, _}, _) do {:const, 0} end
  def deriv({:var, v}, v) do {:const, 1} end
  def deriv({:var, y}, _) do y end
  def deriv({:mul, e1, e2}, v) do {:add,{:mul,e1,deriv(e2,v)}, {:mul,e2,deriv(e1,v)}} end
  def deriv({:add, e1, e2}, v) do {:add, deriv(e1,v), deriv(e2,v)} end
  def deriv({:pwr, e1, {:const, n}}, x) do {:mul, {:const, n} , {:pwr, e1, {:const, n-1}}} end
  def deriv({:ln, x}, x) do {:frac, 1, x} end
  def deriv({:frac, e1, e2}, x) do {:frac, {:sub, {:mul, deriv(e1,x), e2}, {:mul, deriv(e2, x), e1}}, {:pwr, e2, 2}} end
  def deriv({:sqrt, e1}, x) do {:frac, deriv(e1,x), {:mul, {:const, 2}, {:sqrt, e1}}} end
  def deriv({:sin, e1}, x) do {:mul, deriv(e1,x), {:cos, e1}} end
  def deriv({:cos, e1}, x) do {:mul, {:const, -1}, {:mul, deriv(e1,x), {:sin, e1}}} end

  def print({:const, x}) do to_string(x) end
  def print({:var, x}) do to_string(x) end
  def print({:add, e1, e2}) do
    if print(e1) == "0" do print(e2) 
    else if print(e2) == "0" do print(e1)
    else print(e1) <> " + " <> print(e2) end end
  end
  
  def print({:mul, e1, e2}) do
    if print(e1) == "0" or print(e2) == "0" do "0"
    else if print(e1) == "1" do print(e2)
    else if print(e2) == "1"do print(e1)
    else print(e1) <> " * " <> print(e2) end end end
  end
  
  def print({:pwr, e1, e2}) do
    if print(e1) == "0" do "0"
    else if print(e2) =="1" do print(e1)
    else if print(e2) == "0" do "1"
    else print(e1) <> "^" <> print(e2)  end end end
  end
  
  def print({:sub, e1, e2}) do
    if print(e1) == "0" and print(e2) == "0" do "0"
    else if print(e1) == "0" do " - " <> print(e2)
    else if print(e2) == "0" do print(e1)
    else print(e1) <> " - " <> print(e2) end end end
  end
  
  def print({:frac, e1, e2}) do
    if print(e1) == "0" do "0"
    else if print(e2) == "0" do :error
    else print(e1) <> "/" <> print(e2) end end
  end
  
  def print({:sin, e1}) do "sin(" <> print(e1) <> ")" end
  def print({:cos, e1}) do "cos(" <> print(e1) <> ")" end


  
end
