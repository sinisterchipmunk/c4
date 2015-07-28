$ = require 'jquery'
bus = require 'postal'

deslashify = (a) ->
  return '' unless a?.length
  a = a[1..-1] if a.indexOf('/') is 0
  a = a[0...-1] if a.length and a.lastIndexOf('/') is (a.length - 1)
  a

paths_equal = (a, b) ->
  deslashify(a) is deslashify(b)

join_paths = (a, b) ->
  deslashify(deslashify(a) + "/" + deslashify(b))

route_path = (elem) ->
  hierarchy = $(elem).parents("*[data-route], body").addBack("*[data-route]")
  path = ""
  for elem in hierarchy
    path = join_paths path, $(elem).attr 'data-route'
  path

parse_hash = (hash) ->
  params = {}
  index = hash.indexOf '?'
  if index isnt -1
    [query, hash] = [hash, hash[0...index]]
    query.replace new RegExp("([^?=&]+)(=([^&]*))?", "g"),
                  ($0, $1, $2, $3) -> params[$1] = $3 unless $1 is hash
  path: deslashify hash[1..-1]
  params: params

###
  Performs routing for this page based on the given `hash` string. The
  `dom_root` must be the root element of the DOM which will contain matched
  routes.

  The routing process performs the following steps:

      1. Get the query parameters from the hash, if any, and place them into
         the `"params"` broker.
      2. Build a hierarchy of elements with the `data-route` attribute
         present, then find the first complete match. Each element in the
         matching hierarchy is shown, while all other elements with the
         `data-route` attribute are hidden.
      3. Instantiate views from any newly-visible elements which have the
         `data-view` attribute. Note that views that were already visible
         will remain in place, while views that were previously hidden and
         then were displayed during step 3 will be consumed and
         re-instantiated.

  The return value is the processed DOM root.

###
route = (hash, dom_root) ->
  {path, params} = parse_hash hash
  # path = route.params hash
  dom_root = $ dom_root

  # Hide all route nodes, then find route nodes whose total route path matches
  # the current path; show it and all of its parents.
  route_leaf_path = "*[data-route]:not(:has(*[data-route]))"
  route_nodes = dom_root.find("*[data-route]").addBack("*[data-route]")
  route_nodes.hide()
  for leaf in route_nodes
    if paths_equal path, route_path leaf
      $(leaf).show()
      $(leaf).parents("*[data-route]").show()

  # Consume views in the remaining hidden route nodes.
  for view in dom_root.find "*[data-view]"
    $view = $ view
    $view.data('implode')?()

  # Instantiate any views that are visible in the nodes that have been shown
  c4.process dom_root#, true

route.params = (hash) ->
  # Strip query params from the hash, and publish them.
  changed = false
  {path, params} = parse_hash hash
  for key, value of c4.broker('params').data
    # if a param wasn't specified at all, publish that it has been removed.
    params[key] = undefined if Object.keys(params).indexOf(key) is -1
    changed = true unless params[key] is value
  c4.broker('params').put params# if changed
  path

module.exports = route

module.exports._init = (c4) ->
  # bus.channel('broker.params').subscribe 'changed', (params) ->
  c4.broker('params').subscribe (params) ->
    hash = document.location.hash
    query = ''
    for key, value of params
      query += "&#{key}=#{value}"
    query = query[1..-1]
    unless hash.indexOf(query) isnt -1
      if hash.indexOf('?') isnt -1
        hash = hash.substring 0, hash.indexOf('?')
      hash += '?' + query
      hash = '#' + hash unless hash[0] is '#'
      history.pushState null, null, hash
