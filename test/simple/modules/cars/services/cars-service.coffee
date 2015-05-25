CARS = [{
  make:  'Dodge'
  model: 'Challenger'
  year:  '2015'
  image: 'http://zombiedrive.com/images/2015-dodge-challenger-4.jpg'
}]

c4 (bus) ->
  # mimics some sort of long load time
  fn = -> bus.channel('cars').publish 'loaded', CARS
  setTimeout fn, 3000
