require './lib/jsmpeg.js'
CameraClient = require './lib/cameraClient'
Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $

StreamsView = Backbone.View.extend
  initialize: (options) ->
    @streamViews = []
  addStreamView: (stream) ->
    $stream = $('<div></div>')
    streamView = new StreamView
      el: $stream
      model: stream
    @$el.append streamView.$el
    @streamViews.push streamView

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
    @set 'id', 1
    @set 'connected', false
    return @

stream = new Stream
  port: 9999

streamsView = new StreamsView
  el: '#streams-view'
streamsView.addStreamView stream

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