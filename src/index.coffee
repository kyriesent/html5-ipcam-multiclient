VideoStream = require 'node-rstp-stream'
config = require '../config'

config.streams.forEach (streamConfig) ->
  videoStream = new VideoStream streamConfig

runStaticHTMLServer = ->
  static_ = require 'node-static'
  file = new static_.Server("./public")

  require("http").createServer((request, response) ->
    request.addListener("end", ->
      file.serve request, response
      return
    ).resume()
    return
  ).listen 80

  console.log "HTTP server listening on port 80"

runStaticHTMLServer()