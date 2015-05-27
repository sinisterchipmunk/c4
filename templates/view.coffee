c4.view '#{module_name}-#{view_name}',
  path: '#{module_name}/views/#{view_name}.html'
  compile: (compiler) ->
    {view, link} = compiler
    {# if services.length {:
    # use the broker service to get a notification any time the query string
    # params change, or any time our services publish new data
    view.broker ['params', #{
      ("#{service}" for service in services).join(', ')
    }], (data) ->
      link
        params: data['params']
        {# for service in services {:#{service}: data['#{service}']
        :} #}
    :} else {:
    # use the broker service to get a notification any time the query string
    # params change
    view.broker ['params'], (data) ->
      link params: data['params']
    :} #}
