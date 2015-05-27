FAKE_DATA = [{
  id: 1,
  value: Math.random(),
  created_at: new Date()
}]

c4.service (bus) ->
  broker = bus.channel 'c4.broker'

  # set default value before trying to load data, or else it's `undefined`
  broker.publish 'put', #{service_name}: '(loading)'

  # mimics some sort of long load time, this might really be ajax or a web
  # worker or whatever
  fn = -> broker.publish 'put', #{service_name}: FAKE_DATA
  setTimeout fn, 3000
