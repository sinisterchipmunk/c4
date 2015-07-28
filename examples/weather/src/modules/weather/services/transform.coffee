c4.service (bus) ->
  weather = c4.broker 'weather'
  params = c4.broker 'params'

  update = ->
    if update.response?.list
      data = update.response.list[0...update.range]
    else data = []

    kelvinToFahrenheit = (kelvin) -> (kelvin - 273.15) * 9 / 5 + 32

    weather.put
      pressures: for d in data
        label: d.dt * 1000
        value: d.main.pressure
      temperatures: for d in data
        label: d.dt * 1000
        value: kelvinToFahrenheit d.main.temp
      humidities: for d in data
        label: d.dt * 1000
        value: d.main.humidity

  params.subscribe 'range', (data) ->
    update.range = data.range
    update()

  weather.subscribe 'response', (data) ->
    update.response = data.response
    update()
