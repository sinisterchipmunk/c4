c4.service (bus) ->
  params = c4.broker 'params'
  weather = c4.broker 'weather'

  params.put city: 4180439 unless params.get 'city'
  weather.put
    cities: [
      {name: 'Atlanta, GA',         id: 4180439}
      {name: 'Boston, MA',          id: 4930956}
      (name: 'Portland, ME',        id: 4975802)
      {name: 'Washington, D.C.',    id: 4140963}
      {name: 'West Palm Beach, FL', id: 4177887}
      {name: 'Wilmington, NC',      id: 4499379}
    ]
