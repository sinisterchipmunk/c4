bus = require 'postal'

data = {}

bus.channel('c4.broker').subscribe 'put', (info) ->
  for prop, value of info
    data[prop] = value
  true

bus.channel('c4.broker').subscribe 'get', (info) ->
  props = {}
  for prop in info.keys
    props[prop] = data[prop]
  info.ready props
