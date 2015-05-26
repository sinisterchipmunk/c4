global.$ = require 'jquery'
$ = require 'jquery'
bus = require 'postal'
view = require './view'
routing = require './routing'

bus.channel('c4').subscribe 'ready', ->
  pending = 0
  # first evaluate any modules in page, then begin routing
  for module in $('*[data-module]')
    do (module) ->
      $module = $ module
      route_prefix = routing.route_for $module
      mod_name = $module.attr 'data-module'
      pending++
      $.get "/modules/#{mod_name}/views/index.html", (content) ->
        $module.html content
        routing.prefix route_prefix, $module
        pending--
        bus.channel('c4').publish 'routing' if pending is 0
  true
