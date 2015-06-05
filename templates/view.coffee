c4.view '#{module_name}-#{view_name}',
  path: '/modules/#{module_name}/views/#{view_name}.html'
  compile: (compiler) ->
    {view, link} = compiler
    data =
      params: {}
      {# for service in services {:#{service}: null
      :} #}
    # use the broker service to get a notification any time the query string
    # params change...
    c4.broker 'params', (params) ->
      data.params = params || {}
      link data
    {# if services.length {:
    # ... or any time our services publish new data
    c4.broker '#{module_name}', (module_data) ->
      {# for service in services {:data['#{service}'] = module_data['#{service}']
      :}
      #}link data
    :} #}
