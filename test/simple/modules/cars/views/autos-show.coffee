c4.view 'autos-show',
  path: '/modules/cars/views/show.html'
  init: (bus) ->
    autos = null
    selection = null

    bus.channel('cars').subscribe 'loaded', (data) ->
      autos = data
      bus.channel('autos-show').publish 'stale'

    bus.channel('autos-show').subscribe 'params', (data) ->
      selection = data.auto
      bus.channel('autos-show').publish 'stale'

    bus.channel('autos-show').subscribe 'compile', (compile) ->
      compile.link
        auto: autos?[selection]
