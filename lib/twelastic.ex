defmodule Twelastic do
  @moduledoc """
  Get tweets of certain stuff
  """

  @doc """
    Twitter indexer for racist people
  """

  def tweets do
    ExTwitter.stream_filter(track: "foobar") |>
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

  def main do
    Elastix.start()
    IndexR.indexTweets
  end
end

defmodule IndexR do
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
    Twelastic.tweets |>
    Stream.map(&IndexR.indexTweet/1) |>
    Stream.map(&IO.inspect/1) |>
    Enum.to_list
  end
end

Twelastic.main
