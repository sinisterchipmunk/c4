c4.view 'cars-list',
  path: '/modules/cars/views/list.html'
  init: (bus) ->
    cars = null

    bus.channel('cars').subscribe 'loaded', (data) ->
      cars = data
      bus.channel('cars-list').publish 'stale'

    bus.channel('cars-list').subscribe 'compile', (compile) ->
      compile.link
        cars: cars
        source: 'cars'
