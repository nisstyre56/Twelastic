import React from 'react'
import R from 'ramda'

function renderTweet(tweet) {
  return (
    <div key={tweet.tweet.text}
         className="tile animated fadeIn"
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
      if (this.state.paused) {
        return;
      }
      this.setState(
        {
          "tweets" : R.prepend(tweet,
                               (this.state.tweets.length > 12 ?
                                  R.dropLast(1, this.state.tweets) :
                                  this.state.tweets))
        }
      )
    })

    this.pause = () => {
      this.setState({
        "paused" : !this.state.paused
      });
    }

    this.state = {
      "tweets" : [],
      "paused" : false
    }
  }

  render() {
    return (
      <div className="tweets">
        { renderTweets(this.state.tweets) }
        <button
          onClick={this.pause}
          className="btn btn-primary"
        >
          { this.state.paused ? "Start" : "Pause" }
        </button>
      </div>
    );
  }
}

export default Tweets
