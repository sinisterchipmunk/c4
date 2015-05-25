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

append_path = (a, b) -> strip_path "#{strip_path a}/#{strip_path b}"

parse_hash = (hash) ->
  params = {}
  index = hash.indexOf '?'
  if index isnt -1
    [query, hash] = [hash, hash[0...index]]
    query.replace new RegExp("([^?=&]+)(=([^&]*))?", "g"),
                  ($0, $1, $2, $3) -> params[$1] = $3 unless $1 is hash
  path: strip_path hash[1..-1]
  params: params

onchange = ->
  # hide any data-route elements; later we'll show the one we've routed to
  $('*[data-route]').hide()

  {path, params} = parse_hash document.location.hash

  full_path = (stack) ->
    stack.reduce ((a, b) -> append_path a, b.attr 'data-route'), ''

  # get all leaf routes, that is, routes that do not contain nested routes;
  # and then construct route paths from them and their parents. First match
  # wins.
  for ele in $('*[data-route]:not(:has(*[data-route]))')
    $ele = $ ele
    nodes = ($ parent for parent in $ele.parents("*[data-route]"))
    nodes.push $ele
    current_path = full_path nodes
    if current_path is path
      bus.channel('routes').publish 'show',
        route:  $ele
        params: params
      return true

  console.warn 'no route found for hash path', path, params
  false

window.addEventListener 'hashchange', (evt) ->
  onchange()

bus.channel('c4').subscribe 'ready', ->
  onchange()

  # bus.channel('routing').publish '/', {}
