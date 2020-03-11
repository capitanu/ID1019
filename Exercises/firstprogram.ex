defmodule Test do
  def double(n) do
    2 * n
  end

  def fartocel(f) do
    (f - 32) / 1.8
  end

  def area(a,b) do
    a*b
  end

  def areasq(a) do
    area(a,a)
  end

  def areacirc(r) do
    :math.pi() * r * r
  end
end
