
config = require './config'
uuid = require 'node-uuid'

w = window.innerWidth
h = window.innerHeight

randomInt = (x) ->
  Math.floor (Math.random() * x)

distance = (a, b) ->
  diffX = Math.abs (a.x - b.x)
  diffY = Math.abs (a.y - b.y)
  diffX + diffY

makePoint = (level) ->
  x: randomInt w
  y: randomInt h
  level: level
  id: uuid.v1()

isPointOk = (points, point) ->
  for oldPoint in points
    if (distance oldPoint, point) < config.minDistance
      return no
  return yes

exports.generate = ->
  points = []
  lines = []

  level = 0
  initalPoint = makePoint level
  points.push initalPoint

  for level in [1..config.level]
    for oldPoint in points
      if oldPoint.level is (level - 1)
        for _ in [1..config.branch]
          randomPoint = makePoint level
          valid = isPointOk points, randomPoint
          if valid
            points.push randomPoint
            lines.push a: oldPoint.id, b: randomPoint.id

  {points, lines}

exports.findStart = (points) ->
  base = x: 0, y: 0
  start = x: w, y: h
  for point in points
    if (distance point, base) < (distance start, base)
      start = point
  start.id

exports.findEnd = (points) ->
  base = x: w, y: h
  end = x: 0, y: 0
  for point in points
    if (distance point, base) < (distance end, base)
      end = point
  end.id

exports.readLine = (line, points) ->
  info = {}
  for point in points
    if point.id is line.a
      info.a = point
    if point.id is line.b
      info.b = point
  return info

exports.isActivePoint = (id, at, lines) ->
  for line in lines
    if (line.a is id) and (line.b is at)
      return yes
    if (line.a is at) and (line.b is id)
      return yes
  return no

exports.inSpot = (x, y) ->
  (distance {x, y}, @) < (2 * @r)