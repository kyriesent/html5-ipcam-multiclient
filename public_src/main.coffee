require './lib/jsmpeg.js'
CameraClient = require './lib/cameraClient'
io = require 'socket.io-client'
Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'
Backbone.$ = $

StreamsView = Backbone.View.extend
  initialize: (options) ->
    @streamViews = []
  addStreamView: (stream) ->
    return if @getStreamView(stream.id)?
    $stream = $('<div></div>')
    streamView = new StreamView
      el: $stream
      model: stream
    @$el.append streamView.$el
    @streamViews.push streamView
  getStreamView: (id) ->
    return _.find @streamViews, (streamView) ->
      streamView.model.get('id') is id

StreamView = Backbone.View.extend
  initialize: (options) ->
    @render(options)
  render: (options) ->
    @$el.html @template @model.attributes
    @startStream()
  template: (attributes) ->
    template = Handlebars.compile $('#streams-template').html()
    template attributes
  startStream: () ->
    canvas = @$('canvas')[0]
    @cameraClient = new CameraClient canvas, @model.get 'port'

Stream = Backbone.Model.extend
  initialize: (attributes, options) ->
    @set 'connected', false
    return @

streamsView = new StreamsView
  el: '#streams-view'

dataSocket = io()

dataSocket.on 'camera metadata', (streams) ->
  _.each streams, (streamConfig) ->
    stream = new Stream
      id: streamConfig.id
      name: streamConfig.name
      port: streamConfig.wsPort
    streamsView.addStreamView stream

  iso = new Isotope '#streams-view', {
    itemSelector: '.video-canvas'
    masonry: {
      columnWidth: '.grid-sizer'
    }
  }

# multistream = Ember.Application.create()
# multistream.ApplicationAdapter = DS.FixtureAdapter.extend();

# multistream.Router.map ->
#   @resource 'streams',
#     path: '/'

# multistream.StreamsRoute = Ember.Route.extend
#   model: ->
#     @store.find 'stream'

# multistream.Stream = DS.Model.extend
#   port: DS.attr 'number'
#   connected: DS.attr 'boolean'

# multistream.Stream.FIXTURES = [
#   id: 1
#   port: 9999
#   connected: false
# ]

# multistream.StreamsController = Ember.ArrayController.extend
#   actions:
#     createStream: ->
#       stream = this.store.createRecord 'stream',
#         id: 'abcd'
#         port: 9999
#       stream.save()