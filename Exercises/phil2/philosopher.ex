defmodule Philosopher do
  @dream 500
  @delay 50
  @eat 20
  @timeout 200
  
  def sleep(t) do :timer.sleep(:rand.uniform(t)) end
  
  def start(hunger, strength, right, left, name, ctrl, seed) do
    spawn_link(fn() -> init(hunger, strength, right, left, name, ctrl, seed) end)
  end

  def init(hunger, strength, right, left, name, ctrl, seed) do
    gui = Gui.start(name)
    :rand.seed(:exsss, {seed, seed, seed})
    dreaming(hunger, strength, right, left, name, ctrl, gui)
  end

  def dreaming(0, strength, right, left, name, ctrl, gui) do
    IO.puts("#{name} is done!")
    send(gui, :stop)
    send(ctrl, :done)      
  end

  def dreaming(hunger, 0, right, left, name, ctrl, gui) do
    IO.puts("#{name} is dead!")
    send(gui, :stop)
    send(ctrl, :done)
  end

  def dreaming(hunger, strength, right, left, name, ctrl, gui) do
    IO.puts("#{name} is dreaming")
    sleep(@dream)
    IO.puts("#{name} wakes up")
    waiting(hunger, strength, right, left, name, ctrl, gui)
  end

  def waiting(hunger, strength, right, left, name, ctrl, gui) do
    send(gui, :waiting)
    IO.puts("#{name} is waiting, #{hunger} hunger left!")
    case Chopstick.request(right, @timeout) do
      :ok ->
	IO.puts("#{name} received left chopstick!")
	sleep(@delay)
	case Chopstick.request(left, @timeout) do
	  :ok ->
	    IO.puts("#{name} received both chopsticks!")
	    eating(hunger, strength, right, left, name, ctrl, gui)
	    send(gui, :leave)
	    dreaming(hunger, strength-1, right, left, name, ctrl, gui)
	  :no ->
	    IO.puts("#{name} could not eat...")
	    Chopstick.return(left)
	    Chopstick.return(right)
	    dreaming(hunger, strength-1, right, left, name, ctrl, gui)
	    send(gui, :leave)
	end
      :no ->
	IO.puts("#{name} could not eat...")
	Chopstick.return(left)
	dreaming(hunger, strength-1, right, left, name, ctrl, gui)
	send(gui, :leave)
    end
  end
  
  def eating(hunger, strength, right, left, name, ctrl, gui) do
    send(gui, :enter)
    IO.puts("#{name} is eating...")
    sleep(@eat)
    Chopstick.return(left)
    Chopstick.return(right)
    send(gui, :leave)
    dreaming(hunger- 1, strength, right, left, name, ctrl, gui)
  end
end
