c4.view 'autos-list',
  path: '/modules/cars/views/list.html'
  init: (bus) ->
    autos = null

    bus.channel('cars').subscribe 'loaded', (data) ->
      autos = data
      bus.channel('autos-list').publish 'stale'

    bus.channel('autos-list').subscribe 'compile', (compile) ->
      compile.link
        autos: autos
        source: 'cars'
