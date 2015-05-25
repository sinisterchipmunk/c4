c4.view 'autos-show',
  path: '/modules/cars/views/show.html'
  init: (bus) ->
    autos = null
    selection = null

    bus.channel('autos-show').subscribe 'params', (data) ->
      selection = data.auto
      bus.channel('autos-show').publish 'stale'

    # kind of a hack, would be better to scope tighter to the data we can
    # receive, but it's not possible to know what that is at this layer
    bus.channel('c4.broker').subscribe 'put', (data) ->
      bus.channel('autos-show').publish 'stale'

    bus.channel('autos-show').subscribe 'compile', (compile) ->
      key = compile.view.attr 'data-source'
      bus.channel('c4.broker').publish 'get',
        keys: [key]
        ready: (data) ->
          compile.link
            auto: data[key]?[selection]
