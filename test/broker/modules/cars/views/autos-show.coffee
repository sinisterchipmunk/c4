c4.view 'autos-show',
  path: '/modules/cars/views/show.html'
  init: (bus) ->
    selection = null

    bus.channel('autos-show').subscribe 'params', (data) ->
      selection = data.auto
      bus.channel('autos-show').publish 'stale'

    bus.channel('autos-show').subscribe 'compile', (compiler) ->
      {view, link} = compiler
      key = view.attr 'data-source'
      view.broker [key], (data) ->
        link auto: data[key]?[selection]
