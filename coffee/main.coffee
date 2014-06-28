
model = require './model'
require './render'

model.reset()

window.onkeydown = (event) ->
  if event.keyCode is 32
    model.reset()