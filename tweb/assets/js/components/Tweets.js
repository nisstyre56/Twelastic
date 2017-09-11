import React from 'react'
import R from 'ramda'

function renderTweet(tweet) {
  return (
    <div key={tweet.tweet.text}
         className="tile"
    >
      <div className="tile-content">
        <h4 className="tile-subtitle tweet">
          {tweet.tweet.text}
        </h4>
        <span className="divider"></span>
      </div>
    </div>
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
          "tweets" : R.prepend(tweet,
                               (this.state.tweets.length > 12 ?
                                  R.dropLast(1, this.state.tweets) :
                                  this.state.tweets))
        }
      )
    })

    this.state = {
      "tweets" : []
    }
  }

  render() {
    return (
      <div className="tweets">
        { renderTweets(this.state.tweets) }
      </div>
    );
  }
}

export default Tweets
