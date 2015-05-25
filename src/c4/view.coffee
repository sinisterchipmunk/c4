$ = require 'jquery'
bus = require 'postal'
toffee = require 'toffee'

bus.channel('view').subscribe 'file', (path) ->
  $.get path, (body) ->
    $(document.body).html body

VIEWS = {}

uniq = (ary) ->
  result = []
  for ele in ary
    result.push ele if result.indexOf(ele) is -1
  result

# the set of all instantiated views which are being displayed as a result of
# the current route
current_route = null

cleanup = (route) ->
  return unless route
  # TODO if we provide an interface into bus instead of bus itself, we can
  # consume subscriptions automagically here instead of forcing manual cleanup
  views = route.find("*[data-view]").addBack("*[data-view]")
  for view in views
    $view = $ view
    subs = $view.data 'c4.broker.subscriptions'
    if subs
      for sub in subs
        sub.unsubscribe()
    $view.data 'c4.broker.subscriptions', []
    bus.channel($view.attr 'data-view').publish 'release', $view
  true

bus.channel('routes').subscribe 'show', (info) ->
  # when route changes, all existing views should have a chance to unsubscribe
  cleanup current_route
  # when route changes, delegate params into views attached to the new route
  {route, params} = info
  $affected_views = route.find("*[data-view]").addBack("*[data-view]")
  affected_view_names = uniq (ele for ele in $affected_views).map (a) ->
    $(a).attr 'data-view'
  bus.channel(view).publish 'params', params for view in affected_view_names
  # when route changes, (re)compile associated stale views
  current_route = route
  for view in $affected_views
    $view = $ view
    metaview = VIEWS[$view.attr 'data-view']
    unless metaview
      console.warn "missing metaview for view", view
      continue
    if metaview.template
      bus.channel('view').publish 'template-ready', metaview
  true

###
  The view name is the XHTML tag that will invoke this view from other views
  or from the DOM. If it exists, it will be replaced. Existing instances of
  the conflicting view will be replaced with instances of the new view as
  soon as it is ready.

  `options` can contain the following keys:
  * `path`: a URL or path to an XHTML partial template
  * `template`: a string of XHTML/Toffee template code, to be used instead of
                the `path` option. If both are present, `template` takes
                precedence.
  * `init`: a callback function which will be invoked as soon as the view
            is instantiated. This does not mean the view is actually being
            used, and `init` is only ever called once for a given view.
            `this` is undefined. Views should subscribe to channels within
            this function. It is guaranteed to be invoked before the
            application at large is started.
  * `compile`: a callback function which will be invoked whenever the view
               is compiled. This is shorthand for hooking up a `compile`
               subscriber to a channel with the same name as the view during
               `init`, but this approach is preferred where possible.
###
module.exports = (view_name, metaview) ->
  metaview.name = view_name
  VIEWS[view_name] = metaview
  if metaview.compile
    bus.channel(view_name).subscribe 'compile', metaview.compile
  bus.channel(view_name).subscribe 'stale', ->
    if metaview.template
      bus.channel('view').publish 'template-ready', metaview
    # else, it's still loading

partial_fn = (filename, context) -> "PARTIALS NOT IMPLEMENTED"

exports.prepare_view = (view) ->
  # perf: don't compile a template if it isn't part of the current route
  # console.log current_route, view, current_route.has(view)
  $view = $ view
  metaview = VIEWS[$view.attr 'data-view']
  throw new Error 'metaview not found for view', view unless metaview
  $view.broker = (keys, fn) ->
    subs = $view.data('c4.broker.subscriptions') || []
    timeout = null
    props = {}
    callback = -> fn props
    for key in keys
      props[key] = undefined
      do (key) ->
        subs.push bus.channel('c4.broker').subscribe key, (data) ->
          props[key] = data
          clearTimeout timeout
          # ensures fn only gets called once for a set of rapidly changing
          # keys
          timeout = setTimeout callback, 20
    $view.data 'c4.broker.subscriptions', subs
    true
  bus.channel(metaview.name).publish 'compile',
    view: $view,
    link: (context = {}) ->
      unless typeof context is 'object'
        throw new Error 'context must be an object'
      context_copy = Object.create context
      context_copy.partial or= partial_fn
      [err, res] = new toffee.view(metaview.template).run context_copy
      throw err if err
      bus.channel(metaview.name).publish 'compiled', context
      $res = $ "<span>#{res}</span>"
      for new_view in $res.find("*[data-view]").addBack("*[data-view]")
        exports.prepare_view new_view
      $(view).html $res.children()


bus.channel('view').subscribe 'template-ready', (metaview) ->
  # at this stage, a view is ready to be instantiated. Search the dom for
  # invocations of this metaview, and for each match, instantiate the dom and
  # replace the view with its content.
  return unless current_route
  relevant_views = current_route.find("*[data-view=#{metaview.name}]")
                                .addBack("*[data-view=#{metaview.name}]")
  for view in relevant_views
    continue unless current_route.has view
    exports.prepare_view view
  true

window.addEventListener 'load', ->
  # warn if any view elements are referencing missing views
  for view in $('*[data-view]')
    view_name = $(view).attr 'data-view'
    unless VIEWS[view_name]
      console.warn 'no matching view was found', view

  # load template for each view if necessary, then call its init function.
  # Its ready function only gets called when a copy of it is added to
  # the template, which may happen at boot or may happen dynamically. But
  # the ready function is guaranteed to be called only after all other
  # init functions have been called.
  for name, metaview of VIEWS
    do (name, metaview) ->
      metaview.init? bus  # does it have a template? if not, try to load it
      if metaview.template
        setTimeout -> bus.channel('view').publish 'template-ready', metaview
      else
        unless metaview.path
          console.warn 'view has no template and no path', view
          return
        $.get metaview.path, (template) ->
          metaview.template = template
          bus.channel('view').publish 'template-ready', metaview

  bus.channel('c4').publish 'ready'
  true
