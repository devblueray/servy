defmodule Servy.Plugins do
  alias Servy.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      IO.puts("WARNING #{path} is on the loose!")
    end

    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv), do: %Conv{conv | path: "/wildthings"}
  def rewrite_path(%Conv{} = conv), do: conv

  @doc "Logs 404 request"
  def log(%Conv{} = conv), do: IO.inspect(conv)
end
