bus = require 'postal'

data = {}

bus.channel('postal').subscribe 'subscription.created', (info) ->
  if info.channel is 'c4.broker'
    if info.topic isnt 'put' and info.topic isnt 'get'
      bus.channel('c4.broker').publish info.topic, data[info.topic]

bus.channel('c4.broker').subscribe 'put', (info) ->
  for prop, value of info
    data[prop] = value
    bus.channel('c4.broker').publish prop, value
  true

bus.channel('c4.broker').subscribe 'get', (info) ->
  props = {}
  for prop in info.keys
    props[prop] = data[prop]
  info.ready props
