c4.view 'autos-show',
  path: '/modules/autos/views/show.html'
  compile: (compiler) ->
    {view, link} = compiler
    key = view.attr 'data-source'
    view.broker [key, 'params'], (data) ->
      selection = data.params
      link auto: data[key]?[selection]
