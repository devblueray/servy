defmodule Servy.SensorServer do
  alias Servy.VideoCam

  use GenServer
  @name :sensor_server

  defmodule State do
    defstruct refresh_interval: :timer.seconds(5), sensor_data: nil
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  def set_refresh_interval(refresh_interval) do
    GenServer.cast(@name, {:set_refresh_interval, refresh_interval})
  end

  def init(state) do
    initial_state = %{state | sensor_data: run_tasks_to_get_sensor_data()}
    schedule_refresh(state)
    {:ok, initial_state}
  end

  def handle_info(:refresh, state) do
    IO.puts("Refreshing the Cache")
    data = run_tasks_to_get_sensor_data()
    new_state = %{state | sensor_data: data}
    schedule_refresh(new_state)
    {:noreply, new_state}
  end

  defp schedule_refresh(state) do
    Process.send_after(self(), :refresh, state.refresh_interval)
  end

  def handle_cast({:set_refresh_interval, refresh_interval}, state) do
    {:noreply, %{state | refresh_interval: refresh_interval}}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state.sensor_data, state}
  end

  def run_tasks_to_get_sensor_data do
    IO.puts("Running tasks to get sensor data...")

    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
