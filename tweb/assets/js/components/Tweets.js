import React from 'react'
import R from 'ramda'

function renderTweet(tweet) {
  return (
    <li key={tweet.tweet.text}>
      <h4>{tweet.tweet.text}</h4>
    </li>
  );
}

function renderTweets(tweets) {
  return R.map(renderTweet, tweets);
}

class Tweets extends React.Component {
  constructor(props) {
    super(props);
    const ref1 = props.channel.on("tweets", tweet => {
      this.setState(
        {
          "tweets" : R.prepend(tweet, this.state.tweets.length > 10 ? R.dropLast(1, this.state.tweets) : this.state.tweets)
        }
      )
    })

    this.state = {
      "tweets" : []
    }
  }

  render() {
    return (
      <ul>{ renderTweets(this.state.tweets) }</ul>
    );
  }
}

export default Tweets
