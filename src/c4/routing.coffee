bus = require 'postal'
$ = require 'jquery'

bus.channel('routes').subscribe 'show', (info) ->
  {route, params} = info
  route.parents("*[data-route]").show()
  route.show()
  true

strip_path = (a) ->
  a = a[0...-1] if /\/$/.test a
  a = a[1..-1]  if /^\//.test a
  a

parse_hash = (hash) ->
  params = {}
  index = hash.indexOf '?'
  if index isnt -1
    [query, hash] = [hash, hash[0...index]]
    query.replace new RegExp("([^?=&]+)(=([^&]*))?", "g"),
                  ($0, $1, $2, $3) -> params[$1] = $3 unless $1 is hash
  path: strip_path hash[1..-1]
  params: params

exports.join_route = (a, b) -> strip_path "#{strip_path a}/#{strip_path b}"

full_path = (stack) ->
  stack.reduce ((a, b) -> exports.join_route a, b.attr 'data-route'), ''

exports.route_for = ($el) ->
  nodes = ($ parent for parent in $el.parents("*[data-route]")).reverse()
  nodes.push $el if $el.attr('data-route') isnt undefined
  full_path nodes

exports.prefix = (route_prefix, $view_root) ->
  # prefix module links to be internal to module
  for a in $view_root.find("a")
    $a = $ a
    href = $a.attr 'href'
    if href?[0] is '#'
      if href.indexOf route_prefix isnt 1
        corrected_route = exports.join_route route_prefix, href[1..-1]
        $a.attr 'href', "##{corrected_route}"
  true

onchange = ->
  # hide any data-route elements; later we'll show the one we've routed to
  $('*[data-route]').hide()

  {path, params} = parse_hash document.location.hash
  bus.channel('c4.broker').publish 'put', params: params

  # get all leaf routes, that is, routes that do not contain nested routes;
  # and then construct route paths from them and their parents. First match
  # wins.
  for ele in $('*[data-route]:not(:has(*[data-route]))')
    $ele = $ ele
    current_path = exports.route_for $ele
    if current_path is path
      bus.channel('routes').publish 'show',
        route:  $ele
        params: params
      return true

  # if the path is blank (root route), then match the document body.
  if path is ''
    bus.channel('routes').publish 'show',
      route: $ document.body
      params: params

  console.warn 'no route found for hash path', path, params
  false

window.addEventListener 'hashchange', (evt) ->
  onchange()

bus.channel('c4').subscribe 'routing', ->
  onchange()
