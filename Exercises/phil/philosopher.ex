defmodule Philosopher do

  @dream 400
  @eat 100
  @delay 50

  @timeout 1000
  
  def sleep(t) do :timer.sleep(:rand.uniform(t)) end

  def init(hunger, strength, left, right, name, ctrl, seed) do
    gui = Gui.start(name)
    :rand.seed(:exsss, {seed, seed, seed})
    dreaming(hunger, strength, left, right, name, ctrl, gui)
  end
  
  def start(hunger, strength, left, right, name, ctrl, seed) do
    philo = spawn_link(fn -> init(hunger, strength, left, right, name, ctrl, seed) end) end

  def dreaming(hunger, 0, left, right, name, ctrl, gui) do
    IO.puts("#{name} is starved to death, hunger is down to #{hunger}!")
    send(gui, :stop)
    send(ctrl, :done)
  end

  def dreaming(0, strength, left, right, name, ctrl, gui) do
    IO.puts("#{name} is happy, strength is still #{strength}!")
    send(gui, :stop)
      
send(ctrl, :done)end

  def dreaming(hunger, strength, left, right, name, ctrl, gui) do
    IO.puts("#{name} is dreaming!")
    sleep(@dream)
    IO.puts("#{name} woke up!")
    waiting(hunger, strength, left, right, name, ctrl, gui)
  end

  def waiting(hunger, strength, left, right, name, ctrl, gui) do
    send(gui, :waiting)
    IO.puts("#{name} is waiting, #{hunger} left!")
    case Chopstick.request(left) do
      :ok ->
	IO.puts("#{name} received left chopstick")
	sleep(@delay)
	case Chopstick.request(right) do
	  :ok ->
	    IO.puts("#{name} received both chopsticks!")
	    eating(hunger, strength, left, right, name, ctrl, gui)
	    send(gui, :leave)
	    dreaming(hunger, strength - 1, left, right, name, ctrl, gui)
	end
    end
  end

  def eating(hunger, strength, left, right, name, ctrl, gui) do
    send(gui, :enter)
    IO.puts("#{name} is eating!")
    sleep(@eating)

    Chopstick.return(left)
    Chopstick.return(right)
    send(gui, :leave)
    dreaming(hunger - 1, strength, left, right, name, ctrl, gui)
  end
end
