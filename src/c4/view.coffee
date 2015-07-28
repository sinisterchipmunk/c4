$ = require 'jquery'
bus = require 'postal/lib/postal.lodash.js'

VIEWS = {}

###
  Unique ID to track view instances. Incremented every time a new view is
  instantiated.
###
VIEW_ID = 0

view = (name, metaview) ->
  if metaview is null
    delete VIEWS[name]
  else
    metaview.name = name
    VIEWS[name] = metaview if metaview
  VIEWS[name]

extensions =
  subscriptions: ($view) ->
    $view.data '_subscriptions'

  ###
    Releases all of this view's subscriptions, then removes the view from the
    DOM.
  ###
  implode: ($view) ->
    for sub in $view.subscriptions()
      sub.unsubscribe()
    $view.removeAttr 'data-view-id'

  ###
    Pass-through to `c4.broker` that tracks the resultant subscription, so
    that when this view is consumed the subscriptions can be released.
  ###
  broker: ($view, args...) ->
    subscriptions = $view.subscriptions()
    result = c4.broker args...
    if result.length
      subscriptions.push result...
    else subscriptions.push result
    true

###
  Adds extra view-specific instance methods to `$view`.
###
extend = ($view) ->
  $view.attr 'data-instance-id', ++VIEW_ID
  $view.data '_subscriptions', []
  for ext, func of extensions
    do (func) ->
      fn = -> func.call $view, $view, arguments...
      $view.data ext, fn
      $view[ext] = fn
  true

compile = (metaview, $elem) ->
  extend $elem

  metaview.compile
    view: $elem
    bus: bus
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

view._process = (fragment, only_visible = false) ->
  $view = $ fragment
  return $view if $view.attr 'data-view-id'
  name = $view.attr 'data-view'
  metaview = VIEWS[name]
  if metaview
    # don't instantiate a view that is already running
    if only_visible
      compile metaview, $view if $view.is ':visible'
    else
      compile metaview, $view
  else
    elems = $view.find "*[data-view]"
    for elem in elems
      view._process elem, only_visible
  $view

view._init = ->

module.exports = view
