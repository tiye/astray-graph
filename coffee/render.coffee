
vm = require './view-model'

w = window.innerWidth
h = window.innerHeight

canvas = document.querySelector 'canvas'
canvas.width = w
canvas.height = h

ctx = canvas.getContext '2d'

vm.on 'change', ->
  ctx.clearRect 0, 0, w, h

  shapes = vm.get()

  for shape in shapes
    if shape.type is 'spot'
      ctx.beginPath()
      ctx.fillStyle = shape.color
      ctx.arc shape.x, shape.y, shape.r,
        0, (Math.PI * 2)
      ctx.closePath()
      ctx.fill()

    else if shape.type is 'line'
      ctx.beginPath()
      ctx.strokeStyle = shape.color
      ctx.lineWidth = shape.width
      ctx.moveTo shape.x, shape.y
      ctx.lineTo shape.ex, shape.ey
      ctx.stroke()

  if vm.isSucceed()
    showSuccess()

showSuccess = ->
  ctx.font = '80px Optima'
  ctx.textAlign = 'center'
  ctx.textBaseline = 'middle'
  ctx.fillText 'Success', (w/2), (h/2)

canvas.onclick = (event) ->
  vm.locate event.x, event.y