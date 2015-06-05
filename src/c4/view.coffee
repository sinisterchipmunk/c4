$ = require 'jquery'

VIEWS = {}

view = (name, metaview) ->
  if metaview is null
    delete VIEWS[name]
  else
    metaview.name = name
    VIEWS[name] = metaview if metaview
  VIEWS[name]

compile = (metaview, $elem) ->
  metaview.compile
    view: $elem
    link: (context) ->
      template = toffee.templates[metaview.path]
      unless template
        throw new Error "could not find template #{metaview.path} " +
                        "(referenced by #{metaview.name})"
      result = template.render context
      $elem.html result
      # try to process nested views
      for child in $elem.children()
        view._process child
      true

view._process = (fragment) ->
  $view = $ fragment
  name = $view.attr 'data-view'
  metaview = VIEWS[name]
  if metaview
    compile metaview, $view
  else
    elems = $view.find("*[data-view]") # :not(:has(*[data-view]))')
    for elem in elems
      view._process elem
  $view

view._init = ->

module.exports = view
