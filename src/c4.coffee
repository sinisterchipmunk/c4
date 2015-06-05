###
  Exports a function which, when called, will yield a message bus. Also
  pulls in other C4 source files, most notably `view`, which is exposed as
  a property on the exported function and is used for defining new views.
  See `c4/view.coffee` for more details.

  Example:

      c4 = require 'c4'

  The caller should invoke `c4.init()` when it wishes to begin bootstrapping
  its C4 application(s). Normally this is called from an `onload` window
  event, but could be deferred to some arbitrary point in time if the caller
  wishes to do so.
###

bus = require 'postal/lib/postal.lodash.js'

# wiretap for debugging, needs a lot of work but good enough for now
bus.addWireTap (o, env) ->
  console.debug env.timeStamp, env.channel, env.topic, env.data

# A list of bus-listeners which are waiting for `bus` to be yielded to them.
bus_listeners = []

###
  The main entry point for any entity wishing to gain a handle on the C4
  object. Usually, services start with this in order to be able to publish
  data-changed messages to the bus. Views call this function also, but they
  have more abstraction between them and the bus in order to set up DOM
  interactions and the like.
###
c4 = (callback) ->
  bus_listeners.push callback

c4.service = require './c4/service'
c4.broker = require './c4/broker'
c4.view = require './c4/view'

# When `c4` is to be initialized, begin yielding the bus to each listener.
# Then publish a `loaded` message, which might be consumed by other
# components which wish to wait until all listeners have had a chance to
# register themselves.
# bus.channel('c4').subscribe 'init', ->
c4.init = ->
  for listener in bus_listeners
    listener bus
  bus_listeners.splice 0, bus_listeners.length
  bus.channel('c4').publish 'loaded'
  true

c4.reset = ->
  bus.channel('c4').publish 'reset'
  bus.reset()
  ###
    Because we're resetting postal as well, we can't rely on postal to notify
    components that they need to resubscribe. Seems like we should be able
    to monkey patch this with a `persistent` flag or some such to indicate
    that certain subscriptions should survive nuking, but for now I'll take
    the easy way out and just explicitly re-subscribe each component.
  ###
  c4.service._init()
  c4.broker._init()
  c4.view._init()

c4.reset()

###
  Processes an HTML fragment and returns a view. It is important to note that
  a view is simply an HTML fragment which has been tied to a `compile`
  function so that its DOM can be populated. See `c4/view.coffee` for details.
###
c4.process = c4.view._process

module.exports = c4

# FIXME Bad form
global.c4 = c4

# work around an issue in postal - not confident to call it a bug
global.cache or= {}
