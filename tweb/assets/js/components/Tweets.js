import React from 'react'
import R from 'ramda'
import linkifyUrls from 'linkifyjs/string'

function createMarkup(tweet) {
  return {__html: tweet};
};

function renderTweet(tweet) {
  let text = linkifyUrls(tweet.tweet.text, {})
  return (
    <div key={tweet.tweet.text}
         className="tile animated fadeInDown"
    >
      <div className="tile-content">
        <h3> @{ tweet.tweet.author } </h3>
          <h4 className="tile-subtitle tweet">
            <div dangerouslySetInnerHTML={ createMarkup(text) }></div>
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
                               (this.state.tweets.length > 10 ?
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
      <div className="container tweets">
        <div className="columns">
          <div className="column col-10">
            <div style={{"float" : "left"}}>
              { renderTweets(this.state.tweets) }
            </div>
          </div>
          <div className="column col-2">
            <button
              onClick={this.pause}
              className="btn btn-primary"
            >
              { this.state.paused ? "Start" : "Pause" }
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default Tweets
