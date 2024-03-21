defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter

  use GenServer

  def init(state) do
    {:ok, state}
  end
  def start do
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  def get_count(path) do
    GenServer.call(@name, {:get_count, path})
  end

  def bump_count(path) do
    GenServer.call(@name, {:path_not_found, path})
  end

  def get_counts do
    GenServer.call(@name, :get_counts)
  end

  def handle_call({:path_not_found, path}, _from, state) do
    new_state = Map.update(state, path, 1, fn current_count -> current_count + 1 end)
    {:reply, new_state, new_state}
  end

  def handle_call({:get_count, path}, _from, state) do
    count = Map.fetch(state, path)
    {:reply, count, state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end
end
