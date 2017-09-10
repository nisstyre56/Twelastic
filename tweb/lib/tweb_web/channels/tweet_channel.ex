defmodule TwebWeb.TweetChannel do
  use Phoenix.Channel

  def join("tweets:messages", _message, socket) do
    {:ok, socket}
  end

  def send_tweet(tweet) do
    payload = %{"tweet" => tweet}
    IO.puts "XXX"
    TwebWeb.Endpoint.broadcast("tweets:messages", "tweets", payload)
  end

  def handle_in("get_tweets", payload, socket) do
    TwebWeb.Twelastic.tweets |>
    Stream.map(&send_tweet/1) |>
    Enum.to_list
    {:noreply, socket}
  end

  #def get("room:" <> _prmessages, _params, _socket) do
  # {:error, %{reason: "unauthorized"}}
  #end

end
