describe 'c4.route', ->
  html = dom = null
  beforeEach -> html = dom = null

  # tests that care about visibility need to attach the node to the document
  # body or else `:visible` will always be false
  afterEach -> dom?.detach()

  describe 'when query params are present', ->
    params = null

    beforeEach ->
      params = null
      c4.broker 'params', (_params) -> params = _params
      dom = c4.route '/?a=1&b=2', '<div></div>'

    it 'should publish the params', ->
      expect(params).to.deep.equal
        a: '1'
        b: '2'

  describe 'when a query param is not present', ->
    params = null
    a = null

    beforeEach ->
      a = 1
      params =
        a: 1
        b: 1
      c4.broker('params').put params
      c4.broker('params').subscribe 'a', (v) -> a = v
      c4.broker 'params', (_params) -> params = _params
      dom = c4.route '/?b=2', '<div></div>'

    it 'should publish undefined for the missing param', ->
      expect(a).not.to.be.defined
      expect(params).to.deep.equal
        a: undefined
        b: '2'

  describe 'when the route matches exactly', ->
    beforeEach ->
      dom = c4.route '/path', '<div><div data-route="/path">hi!</div></div>'
      document.body.appendChild dom[0]

    it 'should show the div', ->
      expect(dom.children(':visible').text().trim()).to.equal 'hi!'

  describe 'when the route does not match', ->
    beforeEach ->
      dom = c4.route '/path', '<div><div data-route="/path2">hi!</div></div>'
      document.body.appendChild dom[0]

    it 'should hide the div', ->
      expect(dom.children(':visible').text().trim()).to.equal ''

  describe 'nested', ->
    beforeEach ->
      html = '''
        <div>
          <div id='outer' data-route='/outer'>
            <div id='inner' data-route='/path'>hi!</div>
          </div>
        </div>
      '''

    describe 'when the route matches only the parent', ->
      beforeEach ->
        dom = c4.route '/outer/', html
        document.body.appendChild dom[0]

      it 'should hide the inner div', ->
        expect(dom.find('#inner').is ':visible').not.to.be.ok

      it 'should show the outer div', ->
        expect(dom.find('#outer').is ':visible').to.be.ok

    describe 'when the route matches exactly', ->
      beforeEach ->
        dom = c4.route '/outer/path', html
        document.body.appendChild dom[0]

      it 'should show the div', ->
        expect(dom.children(':visible').text().trim()).to.equal 'hi!'

    describe 'when the route does not match', ->
      beforeEach ->
        dom = c4.route '/outer/pat', html
        document.body.appendChild dom[0]

      it 'should hide both route divs', ->
        expect(dom.children('*[data-route]:visible')).to.have.length 0
