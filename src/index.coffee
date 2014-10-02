VideoStream = require 'node-rstp-stream'

# tifa = new VideoStream
#   name: 'tifa'
#   streamUrl: 'rtsp://kyriesent:W1YAMibMu@99.209.16.88:9328/videoMain'
#   wsPort: 9999
#   width: 1280
#   height: 720

videoStream = new VideoStream
  name: 'wowza',
  streamUrl: 'rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov'
  wsPort: 9999
  width: 240
  height: 160

videoStream2 = new VideoStream
  name: 'wowza2',
  streamUrl: 'rtsp://quicktime.uvm.edu:1554/waw/wdi05hs2b.mov'
  wsPort: 9998
  width: 352
  height: 288

# rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov

# CameraSet = require './cameraSet'
# cameraSet = new CameraSet
# cameraSet.addCamera tifa

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

# liveStream = (req, resp) -> # handle each client request by instantiating a new FFMPEG instance
#   # For live streaming, create a fragmented MP4 file with empty moov (no seeking possible).
#   # Can throw URI malformed exception.
#   # Can throw URI malformed exception.
  
#   #'Transfer-Encoding': 'binary'
  
#   #, 'Content-Length': chunksize            // ends after all bytes delivered
#   # Helps Chrome
#   # output to stdout
#   # Keep cam variable active with the selected cam number

#   reqUrl = url.parse(req.url, true)
#   cameraName = (if typeof reqUrl.pathname is "string" then reqUrl.pathname.substring(1) else `undefined`)
#   if cameraName
#     try
#       cameraName = decodeURIComponent(cameraName)
#     catch exception
#       console.log "Live Camera Streamer bad request received - " + reqUrl
#       return false
#   else
#     console.log "Live Camera Streamer - incorrect camera requested " + cameraName
#     return false

#   console.log "Client connection made to live Camera Streamer requesting camera: " + cameraName
#   resp.writeHead 200,
#     Connection: "keep-alive"
#     "Content-Type": "video/mp4"
#     "Accept-Ranges": "bytes"

  
  
 

#   for cam, camera of cameras
#     if cameraName.toLowerCase() is camera.name.toLowerCase()
#       unless camera.liveStarted
#         camera.liveffmpeg = child_process.spawn("ffmpeg", [
#           "-rtsp_transport"
#           "tcp"
#           "-s"
#           "640x480"
#           "-i"
#           camera.rtsp
#           '-b'
#           '800k'
#           '-r'
#           '30'
#           '-'
#           # "-vcodec"
#           # "copy"
#           # "-f"
#           # "mp4"
#           # "-movflags"
#           # "frag_keyframe+empty_moov"
#           # "-reset_timestamps"
#           # "1"
#           # "-vsync"
#           # "1"
#           # "-flags"
#           # "global_header"
#           # "-bsf:v"
#           # "dump_extra"
#           # "-y"
          
#           # "-s"
#           # "640x480"
#           # '-f'
#           # 'video4linux2'
#           # '-i'
#           # '/dev/video0'
#           # '-f'
#           # 'mpeg1video'
#           # '-b'
#           # '800k'
#           # '-r'
#           # '30'

#           # "-"
#         ],
#           detached: false
#         )
#         camera.liveStarted = true
#         camera.liveffmpeg.stdout.pipe resp
#         camera.liveffmpeg.stdout.on "data", (data) ->

#         camera.liveffmpeg.stderr.on "data", (data) ->
#           console.log camera.name + " -> " + data
#           return

#         camera.liveffmpeg.on "exit", (code) ->
#           console.log camera.name + " live FFMPEG terminated with code " + code
#           return

#         camera.liveffmpeg.on "error", (e) ->
#           console.log camera.name + " live FFMPEG system error: " + e
#           return

#       break

#   if camera.liveStarted === false
#     # Didn't select a camera

#   req.on "close", ->
#     shutStream "closed"
#     return

#   req.on "end", ->
#     shutStream "ended"
#     return

#   true

# ###
# ###

# STREAM_SECRET = process.argv[2]
# STREAM_PORT = process.argv[3] or 8082
# WEBSOCKET_PORT = process.argv[4] or 8084
# STREAM_MAGIC_BYTES = "jsmp" # Must be 4 bytes
# width = 320
# height = 240

# # Websocket Server
# socketServer = new (require("ws").Server)(port: WEBSOCKET_PORT)
# socketServer.on "connection", (socket) ->
  
#   # Send magic bytes and video size to the newly connected socket
#   # struct { char magic[4]; unsigned short width, height;}
#   streamHeader = new Buffer(8)
#   streamHeader.write STREAM_MAGIC_BYTES
#   streamHeader.writeUInt16BE width, 4
#   streamHeader.writeUInt16BE height, 6
#   socket.send streamHeader,
#     binary: true

#   console.log "New WebSocket Connection (" + socketServer.clients.length + " total)"
#   socket.on "close", (code, message) ->
#     console.log "Disconnected WebSocket (" + socketServer.clients.length + " total)"
#     return

#   return

# socketServer.broadcast = (data, opts) ->
#   for i of @clients
#     if @clients[i].readyState is 1
#       @clients[i].send data, opts
#     else
#       console.log "Error: Client (" + i + ") not connected."
#   return


# # HTTP Server to accept incomming MPEG Stream
# streamServer = require("http").createServer((request, response) ->
#   params = request.url.substr(1).split("/")
#   width = (params[1] or 320) | 0
#   height = (params[2] or 240) | 0
#   if params[0] is STREAM_SECRET
#     console.log "Stream Connected: " + request.socket.remoteAddress + ":" + request.socket.remotePort + " size: " + width + "x" + height
#     request.on "data", (data) ->
#       socketServer.broadcast data,
#         binary: true

#       return

#   else
#     console.log "Failed Stream Connection: " + request.socket.remoteAddress + request.socket.remotePort + " - wrong secret."
#     response.end()
#   return
# ).listen(STREAM_PORT)
# console.log "Listening for MPEG Stream on http://127.0.0.1:" + STREAM_PORT + "/<secret>/<width>/<height>"
# console.log "Awaiting WebSocket connections on ws://127.0.0.1:" + WEBSOCKET_PORT + "/"