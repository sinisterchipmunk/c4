require 'c4/routing'
require 'c4/broker'

bus = require 'postal'
bus.addWireTap (o, env) ->
  console.debug env.timeStamp, env.channel, env.topic, env.data

c4 = (fn) ->
  fn bus

c4.view = require 'c4/view'

global.c4 = c4
