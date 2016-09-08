HTTPoison.start

defmodule Moon do
  def phases do
    url = "http://api.aerisapi.com/sunmoon/moonphases/search?query=type:new;type:full&limit=1&client_id=FoIH9WlizWZmRZKQec4iN&client_secret=yFVvjj97hbWmOTAZzkbctQqhbZb7ADSvqLMZ8xma"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"error" => nil, "response" => response} = Poison.decode! body
        [%{"code" => _, "dateTimeISO" => date_time, "name" => name, "timestamp" => _}] = response
        {:ok, datetime} = Timex.parse(date_time, "%FT%T%:z", :strftime)
        moon_day = DateTime.to_date(datetime)
        today = DateTime.utc_now |> DateTime.to_date
        if today == today do
          msg = "There is a #{name} tonight :) <3"
          Twilex.Messenger.create("18442422517", "3212929136", msg)
          Twilex.Messenger.create("18442422517", "3214121527", msg)
        end
      _ ->
        IO.puts "failed"
    end
    :timer.sleep(1000 * 60 * 60 * 24)
    phases
  end
end

Moon.phases
