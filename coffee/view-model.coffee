
model = require './model'
{EventEmitter} = require 'events'
config = require './config'
tool = require './tool'

shapes = []

module.exports = vm = new EventEmitter

vm.get = ->
  shapes

vm.update = ->
  store = model.get()
  shapes = []
  for line in store.lines
    lineInfo = tool.readLine line, store.points
    lineShape =
      type: 'line'
      x: lineInfo.a.x
      y: lineInfo.a.y
      ex: lineInfo.b.x
      ey: lineInfo.b.y
      width: config.lineWidth
      color: config.lineColor
    if store.at in [line.a, line.b]
      lineShape.width = config.activeLineWidth
      lineShape.color = config.activeLineColor
    shapes.push lineShape

  for point in store.points
    pointShape =
      id: point.id
      type: 'spot'
      x: point.x
      y: point.y
      r: 3
      color: config.pointColor

    if point.id is store.start
      pointShape.r = 5
      pointShape.color = config.startPointColor
    if point.id is store.end
      pointShape.r = 5
      pointShape.color = config.endPointColor
    if point.id is store.at
      pointShape.r = 5
      pointShape.color = config.atPointColor
    if tool.isActivePoint point.id, store.at, store.lines
      pointShape.r = 7
      pointShape.color = config.activePointColor
      pointShape.hits = tool.inSpot

    shapes.push pointShape

  @emit 'change'

vm.locate = (x, y) ->
  for shape in shapes
    if shape.hits? x, y
      model.choose shape.id

vm.isSucceed = ->
  store = model.get()
  store.at is store.end

model.on 'change', ->
  vm.update()
