describe 'c4.service', ->
  ###
    This is seriously all there is to a service. It just does its thing and
    publishes the results.
  ###
  it 'should run after init completes', ->
    ran = false
    c4.service (bus) -> ran = true
    c4.init()

    expect(ran).to.equal true
