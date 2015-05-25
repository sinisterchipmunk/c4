c4.view 'autos-list',
  path: '/modules/cars/views/list.html'
  init: (bus) ->
    bus.channel('autos-list').subscribe 'compile', (compile) ->
      key = compile.view.attr 'data-source'
      compile.view.brokers [key], (data) ->
        compile.link autos: data[key], source: key
