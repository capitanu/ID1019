defmodule Sort do



  def insert(element, []) do [element] end
  def insert(element, [head | tail]) do
    cond do
      element <= head -> [element | [head | tail]]
      element > head -> [head | insert(element, tail)]
    end
  end

  def isort([]) do [] end
  def isort([head | tail]) do
    if tail == [] do
      insert(head, [])
    else
      insert(head, isort(tail))
    end
  end

  def msort(l) do 
    case l do 
      [] -> []
      [x] -> [x]
      l -> 
        {half1, half2} = msplit(l, [], []) 
        merge(msort(half1), msort(half2)) 
    end 
  end

  def merge([], half2) do half2 end 
  def merge(half1, []) do half1 end 
  def merge([head1 | tail1], [head2 | tail2]) do 
    if head1 < head2 do
      [head1 | merge(tail1, [head2 | tail2]) ]
    else
      [head2 | merge(tail2, [head1 | tail1]) ]
    end 
  end

  
  def msplit(list, half1, half2) do 
    case list do 
      [] -> {half1, half2}
      [head | tail] -> msplit(tail, [head | half2], half1) 
    end
  end

  

  def qsort([]) do [] end
  def qsort([p | l]) do 
    {half1, half2} = qsplit(p, l, [], [])
    small = qsort(half1)
    large = qsort(half2)
    append(small, [p | large])
  end


  def qsplit(_, [], small, large) do {small, large} end
  def qsplit(p, [h | t], small, large) do
    if h <= p  do
      qsplit(p,t,[h | small],large)
    else
      qsplit(p,t,small, [h | large])
    end
  end

  def append(half1, half2) do
    case half1 do
      [] -> half2
      [h | t] -> [h | append(t, half2)]
    end
  end



  
end

