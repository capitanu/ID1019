defmodule Sorter do
  def sorter(n) do spawn(fn() -> init(n) end) end
  def init(sinks) do
    netw = setup(sinks)
    sorter(0, netw)
  end

  def sorter(n, netw) do
    receive do
      {:sort, this} ->
	each(zip(netw, this),
	  fn({cmp, x}) -> send(cmp, {:epoc, n, x}) end)
	sorter(n+1, netw)
      :done ->
	each(netw, fn(cmp) -> send(cmp, {:done,n}) end)
    end
  end

  def setup(sinks) do
    n = length(sinks)
    setup(n, sinks)
  end

  def setup(2, [s1, s2]) do
    cmp = comp(s1, s2)
    [cmp, cmp]
  end

  def merge(2, [s1, s2]) do
    cmp1 = comp(s1, s2)
    [cmp1, cmp1]
  end

  def cross(low, high) do
    cross(low, reverse(high), [])
  end

  def cross([], [], list) do
    {reverse(list), list}
  end

  def cross([l | low], [h | high], crossed) do
    cmp = comp(l, h)
    cross(low, high, [cmp | crossed])
  end

  def setup(4, [s1,s2,s3,s4]) do
    [m1, m2] = merge(2, [s1,s2])
    [m3, m4] = merge(2, [s3,s4])

    {[c1, c2], [c3, c4]} = cross([m1, m2], [m3, m4])

    [i1, i2] = setup(2, [c1, c2])
    [i3, i4] = setup(2, [c3, c4])

    [i1, i2, i3, i4]
  end

  def merge(n, sinks) do
    n = div(n,2)
    {sink_low, sink_high} = split(sinks, n)
    merged_low =  merge(n, sink_low)    
    merged_high =  merge(n, sink_high)
    zipced = zipc(merged_low, merged_high)
    zipced ++ zipced
  end  

  def zipc([], []) do [] end
  def zipc([l|low], [h|high]) do
    cmp = comp(l,h)
    [cmp | zipc(low, high)]
  end
  def setup(n, sinks) do
    n = div(n,2)
    {sink_low, sink_high} = split(sinks, n)
    merge_low = merge(n, sink_low)
    merge_high = merge(n, sink_high)
    {cross_low, cross_high} = cross(merge_low, merge_high)
    in_low = setup(n, cross_low)
    in_high = setup(n, cross_high)
    in_low ++ in_high
  end
end
