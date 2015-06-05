BROKERS = {}

bus = require 'postal/lib/postal.lodash.js'

class Broker
  constructor: (@name) ->
    @channel = bus.channel "broker.#{@name}"
    @subscriptions = []
    @data = {}
    @subscriptions.push @channel.subscribe 'put', @put
    @subscriptions.push bus.channel('postal').subscribe 'subscription.created', (info) =>
      if info.channel is @channel.channel
        if info.topic.indexOf('changed') is 0
          index = info.topic.indexOf '.'
          if index isnt -1
            key = info.topic.substring index + 1, info.topic.length
            @channel.publish info.topic, @data[key]
          else
            @channel.publish info.topic, @data

  subscribe: (names..., callback) ->
    if names.length
      for name in names
        @subscriptions.push @channel.subscribe "changed.#{name}", callback
    else
      @subscriptions.push @channel.subscribe 'changed', callback
    true

  put: (data) =>
    for key, value of data
      @data[key] = value
      @channel.publish "changed.#{key}", value
    @channel.publish 'changed', @data

  cleanup: ->
    subscription.unsubscribe() for subscription in @subscriptions
    true

  clear: ->
    for key, value of @data
      @channel.publish "changed.#{key}", undefined
    @data = {}
    @channel.publish 'changed', @data

broker = (name, subscriber = null) ->
  BROKERS[name] or= new Broker name
  BROKERS[name].subscribe subscriber if subscriber
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
