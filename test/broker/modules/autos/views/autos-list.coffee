c4.view 'autos-list',
  path: '/modules/autos/views/list.html'
  compile: (compiler) ->
    {view, link} = compiler
    key = view.attr 'data-source'
    view.broker [key], (data) ->
      link autos: data[key], source: key

  # init: (bus) ->
  #   bus.channel('autos-list').subscribe 'compile', (compiler) ->
  #     {view, link} = compiler
  #     key = view.attr 'data-source'
  #     view.broker [key], (data) ->
  #       link autos: data[key], source: key
