describe '#{module_name}: #{view_name} view', ->
  view = null
  beforeEach ->
    c4.init()
    view = c4.process '<div data-view="#{module_name}-#{view_name}"></div>'

  it 'should render properly even when all data is undefined', ->
    c4.broker('#{module_name}').clear()
    expect(view.html()).not.to.contain 'error'

  it 'should relink when the broker receives new query params', ->
    c4.broker('params').put id: 1
    expect(view.html()).to.contain '"id":1'
  {# for service, index in services {:
  it 'should relink when the "#{service}" service publishes new data', ->
    c4.broker('#{module_name}').put '#{service}': { id: #{index + 2} }
    expect(view.html()).to.contain '"id":#{index + 2}'
  :} #}
