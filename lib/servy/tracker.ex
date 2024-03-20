defmodule Servy.Tracker do
  def get_location(wildthing) do
    :timer.sleep(500)

    locations = %{
      "roscoe" => %{lat: "44.4280 N", lng: "110.5885 W"},
      "smokey" => %{lat: "48.7596 N", lng: "113.7870 W"},
      "brutus" => %{lat: "43.7904 N", lng: "110.6818 W"},
      "bigfoot" => %{lat: "29.0469 N", lng: "98.8667 W"}
    }

    Map.get(locations, wildthing)
  end
end
