defmodule MetaInt do
  #primitive
  @type variable :: {:var, atom()}
  @type atm :: {:atm, atom()}
  @type dc :: :ignore

  #complex
  @type cons(x) :: {:cons, x, x}
  @type expression:: atm | variable | cons(expression)
  @type sequence :: [expression] | [match | sequence]
  @type match :: {:match, pattern, expression}
  @type pattern :: atm | variable | dc | cons(pattern)
  
end

defmodule Env do
  def new() do [] end
  
  def add(id, str, env) do [{id, str} | env] end

  def args([],[], closure) do [] end
  def args([par | tail], [str | tail2], closure) do [{par, str} | Env.args(tail, tail2,closure)] ++ closure end

						     
  def closure(added, existing) do added ++ existing end

  
  def lookup(id, []) do nil end
  def lookup(id, [{id, value} | rest]) do {id, value} end
  def lookup(id, [ _ | rest]) do lookup(id, rest) end

  def remove(ids, []) do [] end
  def remove(ids, [{ids, value} | rest]) do remove(ids, rest) end
  def remove(ids, [ x | rest]) do [x | remove(ids, rest)] end
end

defmodule Eager do
  
  def eval_expr({:atm, id}, _, _) do {:ok, id} end
  def eval_expr({:var, id}, env, prg) do
    case Env.lookup(id, env) do
      nil -> :error
      {_, str} -> {:ok, str}
    end
  end
  
  def eval_expr({:cons, e1, e2}, env, prg) do
    case eval_expr(e1, env,prg) do
      :error -> :error
      {:ok, str} ->case eval_expr(e2, env, prg) do
		     :error -> :error
		     {:ok, ts} -> {:ok, [str | ts]}
		   end
    end
  end
  
  def eval_expr({:lambda, par, free, seq}, env, prg) do
    case Env.closure(free, env) do
      :error -> :error
      closure -> {:ok, {:closure, par, seq, env}}
    end
  end

  def eval_expr({:apply, expr, args}, env, prg) do
    case eval_expr(expr, env, prg) do
      :error -> :error
      {:ok, {:closure, par, seq, closure}} -> case eval_args(args, env, prg) do
						:error -> :foo
						strs ->
						  env = Env.args(par, strs, closure)
						  eval_seq(seq, env,prg)
	end
    end
  end
  
  def eval_expr({:call, id, args}, env, prg) when is_atom(id) do
  case List.keyfind(prg, id, 0) do
    nil -> :error
    {_, par, seq} ->case eval_args(args, env, prg) do
		      :error -> :error
		      strs -> env = Env.args(par, strs, [])
		      eval_seq(seq, env, prg)
      end
  end
end
  
  def eval_expr({:case, expr, cls}, env,prg) do
    case eval_expr(expr, env,prg) do
      :error -> :error
      {:ok, str} -> eval_cls(cls, str, env, prg)
    end
  end
  def eval_cls([{:clause, ptr, seq} | cls], str, env,prg) do
    env = eval_scope(ptr, env)
    case eval_match(str, ptr, env) do
      :fail ->eval_cls(cls, {:var, str}, env,prg)
      {:ok, env} -> eval_seq(seq, env,prg)
    end
  end
  def eval_cls([], _, _, _) do
    :error
  end

  def eval_args([], _, _) do [] end
  def eval_args([head | tail], env, prg) do
    case eval_expr(head, env, prg) do
      :error -> :error
      {:ok, str} -> case eval_args(tail, env,prg) do
		      :error -> :error
		      full -> [head | tail]
		    end
    end
  end

  def eval_match(:ignore, _ , env) do {:ok, env} end
  def eval_match({:atm, id}, id , env) do {:ok, env} end
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, str, env)}
      {_, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end
  def eval_match({:cons, fst, scd}, [lf | rh], env) do
    case eval_match(fst, lf, env) do
      :fail -> :fail
      {:ok, env} -> eval_match(scd, rh, env)
    end
  end
  def eval_match({:cons, hp, tp}, {:cons, v1, v2}, env) do
    case eval_match(hp, v1, env) do
      :fail -> :fail
      {:ok, envi}-> eval_match(tp, v2, envi)
    end
  end
  def eval_match(_, _, _) do :fail end


  def eval_seq([], env, prg) do env end
  def eval_seq([{:match, right, left} | rest], env, prg) do
    case eval_expr(left, env,prg) do
      :error -> :error
      {:ok, str} -> eval_scope(right, env)
      case eval_match(right, str ,env) do
        :fail -> :error
        {:ok, env} ->  eval_seq(rest, env,prg)
      end
    end
  end
  def eval_seq([exp], env, prg) do
    eval_expr(exp, env,prg)
  end

  def eval_scope(x, env) do Env.remove(extract_vars(x), env) end
  
  def extract_vars(pattern) do extract_vars(pattern, []) end
  def extract_vars({:atm, _ }, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, var}, vars) do [var | vars] end
  def extract_vars({:cons, e1, e2}, vars) do extract_vars(e2, extract_vars(e1,vars)) end

#  def eval(seq) do eval_seq(seq, Env.new(), prg) end
  
end


