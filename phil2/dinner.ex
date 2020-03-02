defmodule Dinner do
  def start(n, seed) do
    dinner = spawn(fn -> init(n, seed) end)
    Process.register(dinner, :dinner)
  end

  def init(n, seed) do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(n, 5, c1, c2, "Arendt", ctrl, seed+1)
    Philosopher.start(n, 5, c2, c3, "Hypatia", ctrl, seed+2)
    Philosopher.start(n, 5, c3, c4, "Simone", ctrl, seed+3)
    Philosopher.start(n, 5, c4, c5, "Elisabeth", ctrl, seed+4)
    Philosopher.start(n, 5, c1, c5, "Ayn", ctrl, seed+5)
    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end

  def wait(n, chopsticks) do
    receive do
      :done ->
	wait(n - 1, chopsticks)
      :abort ->
	Process.exit(self(), :kill)
    end
  end

  def stop() do
    case Process.whereis(:dinner) do
      nil ->
	:ok
      pid ->
	send(pid, :abort)
    end
  end
end
