describe 'c4.broker', ->
  ###
    Broker's methods are just convenience wrappers around the message bus.
    The messages published are still a public API. The intent of the helpers
    is purely to make using the broker more concise, _not_ to hide its
    message interface. Therefore, testing that messages get published when
    the helpers are called is absolutely the right thing to do.
  ###

  describe 'when invoked with a second argument', ->
    sub = null
    beforeEach -> sub = c4.broker 'name', -> undefined
    it 'should return a Subscription object', ->
      expect(sub.unsubscribe).to.be.ok

  describe 'when invoked with no second argument', ->
    broker = null
    beforeEach -> broker = c4.broker 'name'
    it 'should return a Broker object', ->
      expect(broker.subscribe).to.be.ok

  it 'should take an optional subscriber argument for shorthand', ->
    called = 0
    sub1 = -> called++
    sub2 = -> called++
    c4.broker 'name', sub1
    c4.broker 'name', sub2
    expect(called).to.equal 2

  it 'should broadcast an initial `changed` event for each listener even if they are late to the party', (done) ->
    broker = c4.broker 'name'
    broker.put one: 1
    broker.subscribe (data) ->
      expect(data.one).to.equal 1
      done()

  it 'should receive messages published directly to the bus', ->
    # Limitation: postal.js doesn't support wildcards in
    # channels, so we can't have the broker service automagically create
    # brokers when something publishes to the `broker.*` channel. Maybe they'd
    # accept a pull request when there's time to write one...
    c4.broker 'name'

    channel = null
    c4 (bus) -> channel = bus.channel 'broker.name'
    c4.init()

    channel.publish 'put', datum1: 2, datum2: 3
    expect(c4.broker('name').data).to.deep.equal datum1: 2, datum2: 3

  it 'should publish messages to direct subscribers when data is changed', ->
    messages = []
    broker = c4.broker 'name'
    broker.subscribe (d) -> messages.push d
    messages = []

    broker.put datum1: 1, datum2: 2
    expect(messages).to.have.length 1
    expect(messages[0]).to.deep.equal datum1: 1, datum2: 2

    broker.put datum2: 3
    expect(messages).to.have.length 2
    expect(messages[1]).to.deep.equal datum1: 1, datum2: 3

  it 'should publish individual messages to indirect element subscribers when data is changed', ->
    messages = []
    c4 (bus) ->
      bus.channel('broker.name').subscribe 'changed.#', (d) -> messages.push d
    c4.init()

    broker = c4.broker 'name'
    broker.put datum1: 1, datum2: 2
    expect(messages).to.have.length 2
    expect(messages[0]).to.equal 1
    expect(messages[1]).to.equal 2

    broker.put datum2: 3
    expect(messages).to.have.length 3
    expect(messages[2]).to.equal 3

  it 'should publish summary messages to indirect summary subscribers when data is changed', ->
    messages = []
    broker = c4.broker 'name'
    c4 (bus) ->
      bus.channel('broker.name').subscribe 'changed', (d) -> messages.push d
      messages = []
    c4.init()

    broker.put datum1: 1, datum2: 2
    expect(messages).to.have.length 1
    expect(messages[0]).to.deep.equal datum1: 1, datum2: 2

    broker.put datum2: 3
    expect(messages).to.have.length 2
    expect(messages[1]).to.deep.equal datum1: 1, datum2: 3
