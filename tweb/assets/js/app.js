// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import React from 'react'
import { render } from 'react-dom'
import Tweets from './components/Tweets'

let channel = socket.channel("tweets:messages", {})
channel.join()
  .receive("ok", resp => {
    channel.push("get_tweets", {}, 0)
    console.log("Joined successfully", resp)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

//const ref1 = channel.on("tweets", tweet => { return; })

render(<Tweets channel={channel} />, document.getElementById("root"))
