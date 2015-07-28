c4.service (bus) ->
  params = c4.broker 'params'
  weather = c4.broker 'weather'

  params.put range: 4 unless params.get 'range'
  weather.put
    ranges: [
      {name: '12-hour', id: 4}
      {name: '24-hour', id: 8}
    ]
