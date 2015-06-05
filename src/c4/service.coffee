bus = require 'postal/lib/postal.lodash.js'

SERVICES = []

service = (initializer) ->
  SERVICES.push initializer

# re-register known services each time c4 is reset
service._init = ->
  bus.channel('c4').subscribe 'loaded', ->
    initializer bus for initializer in SERVICES
  true

module.exports = service
