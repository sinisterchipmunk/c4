c4.view 'autos-show',
  path: '/modules/cars/views/show.html'
  init: (bus) ->
    selection = null

    bus.channel('autos-show').subscribe 'params', (data) ->
      selection = data.auto
      bus.channel('autos-show').publish 'stale'

    bus.channel('autos-show').subscribe 'compile', (compile) ->
      key = compile.view.attr 'data-source'
      compile.view.brokers [key], (data) ->
        compile.link auto: data[key]?[selection]
