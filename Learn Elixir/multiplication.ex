defmodule Mul do
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
