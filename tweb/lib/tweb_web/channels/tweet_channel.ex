defmodule TwebWeb.TweetChannel do
  use Phoenix.Channel
  def join("tweets:messages", _message, socket) do
    {:ok, socket}
  end

  def handle_in("get_tweets", payload, socket) do
    {:noreply, socket}
  end

  #def get("room:" <> _prmessages, _params, _socket) do
  # {:error, %{reason: "unauthorized"}}
  #end

end
