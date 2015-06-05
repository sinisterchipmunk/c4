describe '#{module_name}: #{service_name} service', ->
  changes_to_#{service_name} = null

  beforeEach ->
    c4.broker '#{module_name}', (data) ->
      changes_to_#{service_name}?.push data
    changes_to_#{service_name} = []
    c4.init()

  it 'should send data to the broker', (done) ->
    setTimeout ->
      expect(changes_to_#{service_name}.length).to.be.above 0
      done()
    , 1000
