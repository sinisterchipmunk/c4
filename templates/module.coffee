c4.view '#{module_name}',
  path: '/modules/#{module_name}/views/index.html'
  compile: (compiler) ->
    {view, link} = compiler
    link {}
