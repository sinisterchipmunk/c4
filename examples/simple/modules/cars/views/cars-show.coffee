c4.view 'cars-show',
  path: '/modules/cars/views/show.html'
  init: (bus) ->
    cars = null
    selection = null

    bus.channel('cars').subscribe 'loaded', (data) ->
      cars = data
      bus.channel('cars-show').publish 'stale'

    bus.channel('cars-show').subscribe 'params', (data) ->
      selection = data.car
      bus.channel('cars-show').publish 'stale'

    bus.channel('cars-show').subscribe 'compile', (compile) ->
      compile.link
        car: cars?[selection]
