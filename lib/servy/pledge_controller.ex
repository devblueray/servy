defmodule Servy.PledgeController do
  alias Servy.Conv

  @templates_path Path.expand("../../templates/", __DIR__)

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %Conv{conv | status: 200, resp_body: content}
  end

  def new(conv) do
    render(conv, "new_pledge.eex", [])
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    IO.inspect(conv)
    Servy.PledgeServer.create_pledge(name, String.to_integer(amount))
    # %Conv{conv | status: 201, resp_body: "#{name} pledged #{amount}!"}
    render(conv, "recent_pledges.eex", pledges: Servy.PledgeServer.recent_pledges())
  end

  def index(conv) do
    pledges = Servy.PledgeServer.recent_pledges()
    render(conv, "recent_pledges.eex", pledges: pledges)
  end
end
