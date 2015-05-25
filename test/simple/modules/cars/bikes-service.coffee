BIKES = [{
  make:  'Kawasaki'
  model: 'Ninja 300'
  year:  '2013'
  image: 'http://www.nicecycle.com/v/vspfiles/photos/2799-27-2.jpg'
}]

c4 (bus) ->
  # mimics some sort of long load time
  fn = -> bus.channel('bikes').publish 'loaded', BIKES
  setTimeout fn, 2800
