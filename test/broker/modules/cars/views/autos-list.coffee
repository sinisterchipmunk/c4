c4.view 'autos-list',
  path: '/modules/cars/views/list.html'
  init: (bus) ->
    bus.channel('autos-list').subscribe 'compile', (compiler) ->
      {view, link} = compiler
      key = view.attr 'data-source'
      view.broker [key], (data) ->
        link autos: data[key], source: key
