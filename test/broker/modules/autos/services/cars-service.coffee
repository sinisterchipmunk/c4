CARS = [{
  make:  'Dodge'
  model: 'Challenger'
  year:  '2015'
  image: 'http://zombiedrive.com/images/2015-dodge-challenger-4.jpg'
}, {
  make: 'Ariel'
  model: 'Atom'
  year: '2015'
  image: 'http://upload.wikimedia.org/wikipedia/commons/8/8a/ArielAtomGoodwood.jpg'
}]

c4 (bus) ->
  # mimics some sort of long load time
  fn = -> bus.channel('c4.broker').publish 'put', cars: CARS
  setTimeout fn, 3000
