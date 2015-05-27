require 'c4/routing'
require 'c4/broker'
require 'c4/module'

bus = require 'postal'
bus.addWireTap (o, env) ->
  console.debug env.timeStamp, env.channel, env.topic, env.data

c4 = (fn) ->
  fn bus

c4.view = require 'c4/view'

# TODO c4 immediately yields a bus, but c4.service should defer yielding until
# c4.ready() is called, which should itself happen sometime around window-load
# after modules have been loaded but before routing or views. This placement
# will make services easier to test and will make their load order a little
# more reliable.
c4.service = c4

global.c4 = c4
