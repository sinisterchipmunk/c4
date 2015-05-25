c4.view 'autos-list',
  path: '/modules/cars/views/list.html'
  init: (bus) ->
    autos = null

    # kind of a hack, would be better to scope tighter to the data we can
    # receive, but it's not possible to know what that is at this layer
    # bus.channel('c4.broker').subscribe 'put', (data) ->
    #   bus.channel('autos-list').publish 'stale'

    bus.channel('autos-list').subscribe 'compile', (compile) ->
      console.log 'compiling'

      key = compile.view.attr 'data-source'

      doCompile = ->
        bus.channel('c4.broker').publish 'get',
          keys: [key]
          ready: (data) ->
            compile.link
              autos: data[key]
              source: key

      bus.channel('c4.broker').subscribe 'put', (data) ->
        doCompile() if data[key]
      doCompile()
