defmodule Servy do
  def hello(name) do
    IO.puts("Howdy #{name}")
  end
end

IO.puts(Servy.hello("Elixir"))
