defmodule Church do
  def to_church(0) do
    fn(_, y) -> y end
  end
  def to_church(n) do
    fn(f, x) -> f.(to_church(n-1).(f, x)) end
  end

  def to_integer(church) do
    church.(fn(x) -> 1 + x end, 0)
  end
  def succ(n) do
    fn(f, x) -> f.(n.(f, x)) end
  end
  def add(n, m) do
    fn(f, x) -> n.(f, m.(f, x)) end
  end
  def mul(n, m) do
    fn(f, x) -> n.(fn(y) -> m.(f, y) end, x) end
  end
  def pred(n) do
    fn(f, x) ->
      ( n.(  # n is a Church numeral
            fn(g) -> fn(h) -> h.(g.(f)) end end,  # apply this function n times 
            fn(_) -> x end)  # to this function 
      ).(fn(u) -> u end)  # apply it to thee identity function
    end
  end
  def minus(n, m) do
    m.(fn(x) -> pred(x) end, n)
  end
  def church_true() do
    fn(x, _) -> x end
  end
  def church_false() do
    fn(_, y) -> y end
  end
  def to_boolean(bool) do
    bool.(true, false)
  end
  def church_and(bool1, bool2) do
    if to_boolean(bool1) == true and to_boolean(bool2) == true do true else false end
  end
  def church_or(bool1, bool2) do
    if to_boolean(bool1) == true or to_boolean(bool2) == true do true else false end
  end
  def is_zero(n) do
    n.(fn(_) -> church_false() end, church_true())
  end
  def if_then_else(bool, tr, fal) do
    bool.(tr, fal)
  end
  def manos(m, n) do
    nr = manos(m, pred(n))
    if_then_else(is_zero(n), m, nr)
  end



  
end
