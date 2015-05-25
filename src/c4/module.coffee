$ = require 'jquery'
bus = require 'postal'
View = require './view'

bus.channel('c4').subscribe 'ready', ->
  # first evaluate any modules in page, then begin routing
  for module in $('*[data-module]')
    $module = $ module
    mod_name = $module.attr 'data-module'
    $.get "/modules/#{mod_name}/views/index.html", (content) ->
      $module.html content
      bus.channel('c4').publish 'routing'
  true
