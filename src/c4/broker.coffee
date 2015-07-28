BROKERS = {}

bus = require 'postal/lib/postal.lodash.js'

class Broker
  constructor: (@name) ->
    @channel = bus.channel "broker.#{@name}"
    @subscriptions = []
    @data = {}
    @subscriptions.push @channel.subscribe 'put', @put

  subscribe: (names..., callback) ->
    if names.length
      subscriptions = for name in names
        callback @data
        subscription = @channel.subscribe "changed.#{name}", callback
        @subscriptions.push subscription
        subscription
      return subscriptions
    else
      callback @data
      subscription = @channel.subscribe 'changed', callback
      @subscriptions.push subscription
    subscription

  put: (data) =>
    topics = ['changed']
    for key, value of data
      @data[key] = value
      topics.push "changed.#{key}"
    for topic in topics
      @channel.publish topic, @data
    true

  get: (key) -> @data[key]

  cleanup: ->
    subscription.unsubscribe() for subscription in @subscriptions
    true

  clear: ->
    for key, value of @data
      @channel.publish "changed.#{key}", undefined
    @data = {}
    @channel.publish 'changed', @data

broker = (name, fields..., subscriber = null) ->
  BROKERS[name] or= new Broker name
  if subscriber
    BROKERS[name].subscribe fields..., subscriber
  else
    BROKERS[name]

broker._init = ->
  bus.channel('c4').subscribe 'reset', ->
    for name, broker of BROKERS
      broker.cleanup()
    BROKERS = {}
  # not supported in postal right now
  # bus.channel('broker.*').subscribe 'changed.#', (data, envelope) ->
  #   # yadda yadda new Broker()

module.exports = broker
