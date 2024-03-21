defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  ### Client Functions

  def create_pledge(name, amount) do
    {:ok, _id} = send_pledge_to_service(name, amount)
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledged do
    GenServer.call(@name, :total_pledged)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: pledges}
    {:ok, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{state | cache_size: size}
    {:noreply, new_state}
  end

  def handle_info(message, state) do
    IO.puts("Can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum()
    {:reply, total, state.pledges}
  end

  def handle_call(:recent_pledges, _from, state) do
    most_recent_pledges = Enum.take(state.pledges, state.cache_size)
    new_state = %{state | pledges: most_recent_pledges}
    {:reply, new_state, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id = send_pledge_to_service(name, amount)}
    new_pledges  = [{name, amount} | state.pledges]
    new_state = %{state | pledges: new_pledges}
    IO.inspect( new_state)
    {:reply, id, new_state}
  end

  def handle_call({:clear, _from}) do
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    [{"wilma", 14}, {"fred", 24}]
  end
end

alias Servy.PledgeServer

{:ok, pid} = Servy.PledgeServer.start()
IO.inspect(PledgeServer.create_pledge("larry", 10))
IO.inspect(PledgeServer.recent_pledges())
IO.inspect(PledgeServer.create_pledge("moe", 20))
IO.inspect(PledgeServer.create_pledge("curly", 30))
IO.inspect(PledgeServer.create_pledge("daisy", 40))
IO.inspect(PledgeServer.create_pledge("grace", 50))
IO.inspect(PledgeServer.recent_pledges())
PledgeServer.set_cache_size(4)
IO.inspect(PledgeServer.recent_pledges())
IO.inspect(PledgeServer.total_pledged())
