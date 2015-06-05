describe 'c4', ->
  it 'should yield a bus', ->
    yielded = null
    c4 (bus) -> yielded = bus
    c4.init()
    expect(yielded?.channel).to.be.ok
