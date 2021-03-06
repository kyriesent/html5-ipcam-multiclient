CameraClient = (canvas, port) ->
  ctx = canvas.getContext("2d")
  ctx.fillStyle = "#444"
  ctx.fillText "Loading...", canvas.width / 2 - 30, canvas.height / 3

  # Setup the WebSocket connection and start the player
  wsUrl = 'ws://' + location.host + ':' + port
  client = new WebSocket(wsUrl)
  player = new jsmpeg(client,
    canvas: canvas
  )

  return @

module.exports = CameraClient