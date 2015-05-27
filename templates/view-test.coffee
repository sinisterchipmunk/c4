describe '#{module_name}: #{view_name} view', ->
  it 'should render properly even when all data is undefined', ->
    c4 (bus) -> bus.channel('c4.broker').publish 'clear'
    expect(view.html()).not.toContain 'error'

  it 'should relink when the broker receives new query params', ->
    c4 (bus) -> bus.channel('c4.broker').publish 'params', id: 1
    expect(view.html()).toContain 'id: 1'
