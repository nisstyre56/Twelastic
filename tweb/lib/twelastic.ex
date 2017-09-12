defmodule TwebWeb.Twelastic do
  @moduledoc """
  Get tweets of certain stuff
  """

  @doc """
    Twitter indexer
  """
  def send_tweet(tweet) do
    case ExRated.check_rate("tweets", 1_800, 1) do
      {:ok, _count} -> TwebWeb.Endpoint.broadcast("tweets:messages", "tweets", %{"tweet" => tweet})
      {:error, _count} -> nil
    end
  end

  def broadcast_tweets() do
    TwebWeb.Twelastic.tweets |>
    Stream.each(&send_tweet/1) |>
    Stream.run
  end

  def tweets do
    ExTwitter.stream_filter(track: "Irma") |>
    Stream.filter(fn(tweet) ->
      tweet.retweeted_status == nil
    end) |>

    Stream.map(fn(tweet) ->
      quoted_status =
        case (Map.has_key?(tweet, :quoted_status) and
                           tweet.quoted_status != nil) do
          true ->
            case (Map.has_key?(tweet.quoted_status, :extended_tweet) and
                               tweet.quoted_status.extended_tweet != nil) do
              true -> tweet.quoted_status.extended_tweet.full_text
              false -> ""
            end
          false -> ""
        end

      %{
        :id => tweet.id,
        :text => tweet.text,
        :quoted => quoted_status,
        :author => tweet.user.screen_name,
        :timestamp => tweet.created_at
      }

    end)
  end

  def printTweets do
    TwebWeb.Twelastic.tweets |>
    Stream.map(&IO.inspect/1) |>
    Enum.to_list
  end

  def main do
    #Elastix.start()
    #IndexR.indexTweets
    TwebWeb.Twelastic.printTweets
  end
end

defmodule TwebWeb.IndexR do
  @index_name "twelastic"

  @elastic_url "http://localhost:9200"

  @tweet_mapping %{
    properties: %{
      text: %{type: "text"},
      quoted: %{type: "text"},
      author: %{type: "text"},
      timestamp: %{type: "text"}
    }
  }

  def createMapping do
    Elastix.Mapping.put(@elastic_url,
                        @index_name,
                        "tweet",
                        @tweet_mapping)
  end

  def indexTweet(tweet) do
    Elastix.Document.index(@elastic_url,
                           "twelastic",
                           "tweet",
                           tweet.id,
                           tweet)
  end

  def indexTweets do
    TwebWeb.Twelastic.tweets |>
    Stream.map(&IndexR.indexTweet/1) |>
    Stream.map(&IO.inspect/1) |>
    Enum.to_list
  end
end

#Twelastic.printTweets
