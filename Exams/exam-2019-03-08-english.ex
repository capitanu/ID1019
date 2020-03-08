defmodule Exam2 do
  def decode [] do [] end
  def decode([{elem, 0} | rest]) do decode(rest) end
  def decode([{elem, nr} | rest]) do
    [elem | decode([{elem, nr-1} | rest])]
  end

  def zip([],[]) do [] end
  def zip([elemx | restx],[elemy | resty]) do
    [{elemx, elemy} | zip(restx,resty)]
  end

  def balance(:nil) do {0,0} end
  def balance(tree) do pbalance(tree) end
  def pbalance(:nil) do {0,0} end
  def pbalance({:node, _, :nil, :nil}) do {1,0} end
  def pbalance({:node, _, left, right}) do
    {maxleft, imbalanceleft} = pbalance(left)
    {maxright, imbalanceright} = pbalance(right)
    {1 + max(maxleft,maxright), abs(maxleft-maxright)}
  end

  def eval({:neg,x}) do -x end
  def eval({:add, expr1, expr2}) do eval(expr1) + eval(expr2) end
  def eval({:mul, expr1, expr2}) do eval(expr1)*eval(expr2) end
  def eval(x) do x end


  def update(n,[]) do [] end
  def update(n, [elem | rest]) do
    [[n|elem] | update(n,rest)]
  end
  def gray(n) do
    case n do
      0 -> []
      1 -> [[0],[1]]
      n -> update(0,gray(n-1)) ++ update(1,Enum.reverse(gray(n-1)))
    end
  end

  
  def test() do
    cont = fib()
    {:ok, f1, cont} = cont.()
    {:ok, f2, cont} = cont.()
    {:ok, f3, cont} = cont.()
    [f1,f2,f3]
  end

  def increment() do
    func = fn(x,func) ->if x == 0 do 0 else  1 + func.(x-1,func) end end
    f = fn(f) -> {f, func.(1,func)} end
    fin = fn() -> f.(f) end
    
  end
  def fib() do
    f = fn(x,func) -> 1 + func.(x) end
    fib = fn(x,f) -> case x do
		       0 -> 1
		       1 -> 1
		       x -> fib.(x-1,f.(2,f)) + fib.(x-2,f.(2,f))
		     end end
    f = fn() -> {:ok, fib.(0,f), f.()} end
    
  end
  
  def fac(1) do 1 end
  def fac(n) do
    n * fac(n-1)
  end

  def facl(0) do [1 ]end
  def facl(n) do
    rest = facl(n-1)
    [f | _] = rest
    [n*f | rest]
  end
end

defmodule Proc do
  def start(user) do
    {:ok, spawn(fn() -> proc(user) end)}
  end
  def proc(user) do
    receive do
      {:process, task} ->
	init(task,user)
	proc(user)
      :quit ->
	:ok
    end
  end

  def init(task, user) do
    par = spawn(fn() -> start2() end)
    send(par, {:task,task,user})
  end
  def start2() do
    receive do
      {:task,task,user} ->
	done = task
	send(user,done)
    end
  end
end
