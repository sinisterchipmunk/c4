c4.service (bus) ->
  url = 'http://api.openweathermap.org/data/2.5'
  appId = 'APPID=YOURAPPIDHERE'
  dataType = 'forecast/city'
  weather = c4.broker 'weather'
  params = c4.broker 'params'

  params.subscribe 'city', (data) ->
    api = "#{url}/#{dataType}?#{appId}&id=#{data.city}"

    weather.put response: undefined
    $.get api, (data) ->
      cache[api] = data
      weather.put response: data
