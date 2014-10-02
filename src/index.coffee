VideoStream = require 'node-rstp-stream'
config = require '../config'
_ = require 'underscore'

streams = config.streams

_.each streams, (streamConfig) ->
  console.log "Creating videostream with config:"
  console.log streamConfig
  videoStream = new VideoStream streamConfig

streamIdCounter = 0
streams = _.map streams, (stream) ->
  stream.id = streamIdCounter++
  _.omit stream, 'streamUrl'

runStaticHTMLServer = ->
  static_ = require 'node-static'
  file = new static_.Server("./public")

  server = require("http").createServer((request, response) ->
    request.addListener("end", ->
      file.serve request, response
      return
    ).resume()
    return
  )

  server.listen 80

  console.log "HTTP server listening on port 80"

  return server

staticServer = runStaticHTMLServer()

runWebsocketStreamDataServer = ->
  io = require('socket.io')(staticServer)

  io.on 'connection', (socket) ->
    console.log "USER CONNECTED"
    socket.emit 'camera metadata', streams

runWebsocketStreamDataServer()