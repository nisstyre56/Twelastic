import React from 'react'
import R from 'ramda'

class Tweets extends React.Component {
  constructor(props) {
    super(props);
    const ref1 = props.channel.on("tweets", tweet => {
      this.setState({"tweet" : tweet.tweet.text})
    })

    this.state = {
      "tweet" : ""
    }
  }

  render() {
    return (
      <h3>{ this.state.tweet }</h3>
    );
  }
}

export default Tweets
