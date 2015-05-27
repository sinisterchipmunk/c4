describe '#{module_name}: #{service_name} service', ->
  changes_to_#{service_name} = null

  beforeEach ->
    changes_to_#{service_name} = []
    c4 (bus) ->
      bus.channel('c4.broker').subscribe '#{service_name}', (data) ->
        messages.push data
    c4.ready()

  it 'should send data to the broker', ->
    expect(changes_to_#{service_name}.length).not.toEqual 0
