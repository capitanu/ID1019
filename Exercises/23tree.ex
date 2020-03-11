defmodule B23tree do

  def test do
  insert(3, :grk, {:two, 7, {:three, 2, 5, {:leaf, 2, :foo},
      {:leaf, 5, :bar}, {:leaf, 7, :zot}}, {:three, 13, 16,
      {:leaf, 13, :foo}, {:leaf, 16, :bar}, {:leaf, 18, :zot}}})
  end
  
  def insert(key, value, nil ) do {:leaf, key, value} end


  def insert(k, v, {:two, k1, left, right}) do
    cond do
      k <= k1 ->
	case insert(k, v, left) do
          {:four, q1, q2, q3, t1, t2, t3, t4} -> {:three, q2,k1,t2,{:three, q1,q3,t1,t3,t4} ,right}
          updated -> {:two, k1, updated, right}
	end

      true ->
	case insert(k, v, right) do
          {:four, q1, q2, q3, t1, t2, t3, t4} -> {:three, k1, q2 ,left,t2, {:three, q1,q3,t1,t3,t4}}
          updated -> {:two, k1, left, updated}
	end
    end
  end

  
  def insert(key, value, {:leaf, key1, value1}) do
    if key > key1 do {:two, key1, {:leaf, key1, value1}, {:leaf, key, value}}
    else {:two, key, {:leaf, key, value}, {:leaf, key1, value1}} end
  end
  def insert(key, value, {:two, key1, {:leaf, key1, value1}, {:leaf, key2, value2}}) do
    cond do
      key < key1 -> {:three, key, key1, {:leaf, key, value}, {:leaf, key1, value1}, {:leaf, key2, value2}}
      key < key2 -> {:three, key1, key, {:leaf, key1, value1}, {:leaf, key, value}, {:leaf, key2, value2}}
      key >= key2 -> {:three, key1, key2, {:leaf, key1, value1}, {:leaf, key2, value2}, {:leaf, key, value}}
    end
  end
  def insert(key, value, {:three, key1, key2, {:leaf, key1, value1}, {:leaf, key2, value2}, {:leaf, key3, value3}}) do
    cond do
      key < key1 -> {:four, key, key1, key2, {:leaf, key, value}, {:leaf, key1, value1}, {:leaf, key2, value2},{:leaf, key3, value3}}
      key < key2 -> {:four, key1, key, key2, {:leaf, key1, value1}, {:leaf, key, value}, {:leaf, key2, value2}, {:leaf, key3, value3}}
      key < key3 -> {:four, key1, key2, key, {:leaf, key1, value1}, {:leaf, key2, value2}, {:leaf, key, value}, {:leaf, key3, value3}}
      key >= key3 -> {:four, key1, key2, key3, {:leaf, key1, value1}, {:leaf, key2, value2}, {:leaf, key3, value3}, {:leaf, key, value}}
    end
  end
  
end
