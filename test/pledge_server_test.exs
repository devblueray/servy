defmodule PledgeServerTest do
  use ExUnit.Case
  alias Servy.PledgeServer

  test "pledge server state only returns top 3 pledges" do
    PledgeServer.start()
    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)
    PledgeServer.create_pledge("grace", 50)
    assert PledgeServer.total_pledged() == 120
    assert PledgeServer.recent_pledges() == [{"grace", 50}, {"daisy", 40}, {"curly", 30}]
  end
end
