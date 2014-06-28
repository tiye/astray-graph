
uuid = require 'node-uuid'
EventEmitter = require 'events'
tool = require './tool'

store = {}

module.exports = model = new EventEmitter

model.reset = ->
  sample = tool.generate()
  start = tool.findStart sample.points
  store =
    points: sample.points
    lines: sample.lines
    start: start
    end: tool.findEnd sample.points
    at: start

  @emit 'change'

model.get = ->
  store

model.choose = (id) ->
  store.at = id

  @emit 'change'
