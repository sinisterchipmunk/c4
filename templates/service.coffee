c4.service (bus) ->
  broker = c4.broker '#{module_name}'

  ###
    This is a fake service that publishes a fake message to this module's
    broker every few milliseconds. You probably want to replace all of this
    with something more useful.
  ###

  created_at = new Date()
  fn = ->
    broker.put #{service_name}:
      created_at: created_at
      updated_at: new Date()
      value: Math.random()

  setInterval fn, 100
