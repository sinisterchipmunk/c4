c4.view 'selector',
  path: '/modules/weather/views/selector.html'
  compile: (compiler) ->
    {view, bus, link} = compiler
    params = c4.broker 'params'
    collection = view.attr 'data-collection'
    model = view.attr 'data-model-name'
    
    view.on 'change', 'select', (change) ->
      obj = {}
      obj[model] = view.find('select').val()
      params.put obj

    view.broker 'weather', collection, (data) ->
      link
        items: data[collection]
        selected: parseInt params.get model
