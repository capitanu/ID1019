defmodule Chopstick do
  def start() do
    stick = spawn_link(fn() -> init() end)
    
    {:stick, stick}
  end
  def init() do available() end
  def available() do
    receive do
      :quit ->
	:ok
      {:request, from} ->
	send(from, :granted)
	gone()
    end
  end
  def gone() do
    receive do
      :return ->
	:returned
	available()
      :quit -> :ok
    end
  end

  def request({:stick, spid}, timeout) do
    send(spid, {:request, self()})
    receive do
      :granted -> :ok
    after timeout -> :no
    end
  end

  def return({:stick, spid}) do
    send(spid, :return)
  end

  def quit({:stick, spid}) do
    send(spid, :quit)
  end
  
end
