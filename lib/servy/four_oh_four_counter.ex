defmodule Servy.FourOhFourGenericServer do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, response})
        listen_loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)

      :unexpected ->
        IO.puts("Unexpected Message")
        listen_loop(state, callback_module)
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, value} -> value
    end
  end
end

defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter
  def start do
    Servy.FourOhFourGenericServer.start(__MODULE__, %{}, @name)
  end

  def get_count(path) do
    Servy.FourOhFourGenericServer.call(@name, {:get_count, path})
  end

  def bump_count(path) do
    Servy.FourOhFourGenericServer.call(@name, {:path_not_found, path})
  end

  def get_counts do
    Servy.FourOhFourGenericServer.call(@name, :get_counts)
  end

  def handle_call({:path_not_found, path}, state) do
    new_state = Map.update(state, path, 1, fn current_count -> current_count + 1 end)
    {new_state, new_state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.fetch(state, path)
    {count, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end
end
