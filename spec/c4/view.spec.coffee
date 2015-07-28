describe 'c4.view', ->
  render_context = $view = null

  beforeEach ->
    render_context = $view = null
    window.toffee or= {}
    window.toffee.templates or= {}

    toffee.templates['/test-view'] = render: (context) ->
      render_context = {}
      render_context[k] = v for k, v of context
      return 'rendered'

  afterEach ->
    delete window.toffee.templates['/test-view']
    delete window.toffee.templates['/test-view2']
    c4.view 'test-view', null
    c4.view 'test-view2', null

  describe 'linking via broker', ->
    parent = null

    beforeEach ->
      c4.view 'test-view',
        path: '/test-view'
        compile: (compiler) ->
          {view, link} = compiler
          view.broker 'test-view', (context) ->
            link context
      $view = c4.process '<div data-view="test-view"></div>'
      parent = document.createElement('div')
      parent.appendChild $view[0]

    it 'should render with the default empty object', ->
      expect(render_context).to.be.ok

    it 'should re-render when the broker data changes', ->
      c4.broker('test-view').put one: 1
      expect(render_context.one).to.equal 1

    it 'should place the rendered dom into the view element', ->
      expect($view.text()).to.equal 'rendered'

    describe 'then imploding', ->
      beforeEach -> $view.data('implode')()

      it 'should remove all content from the view', ->
        expect($view.children()).to.have.length 0

      it 'should not remove the view from its parent', ->
        # because it might get recycled
        expect($view.parent()).to.be.defined

      it 'should no longer listen to brokered messages', ->
        c4.broker('test-view').put one: 2
        expect(render_context.one).not.to.equal 2

    xit 'should be possible to nest views', ->

      toffee.templates['/test-view'] = render: (context) ->
        return '<div data-view="test-view2"></div>'

      toffee.templates['/test-view2'] = render: (context) ->
        return 'rendered2'

      c4.view 'test-view2',
        path: '/test-view2'
        compile: (compiler) ->
          {view, link} = compiler
          link context

      $view = c4.process '<div data-view="test-view"></div>'
      expect($view.text()).to.equal 'rendered2'
      done()
      

  describe 'linking immediately', ->
    beforeEach ->
      c4.view 'test-view',
        path: '/test-view'
        compile: (compiler) ->
          {view, link} = compiler
          link context
      $view = c4.process '<div data-view="test-view"></div>'

    it 'should be possible to nest views', ->
      toffee.templates['/test-view'] = render: (context) ->
        return '<div data-view="test-view2"></div>'

      toffee.templates['/test-view2'] = render: (context) ->
        return 'rendered2'

      c4.view 'test-view2',
        path: '/test-view2'
        compile: (compiler) ->
          {view, link} = compiler
          link context

      $view = c4.process '<div data-view="test-view"></div>'
      expect($view.text()).to.equal 'rendered2'
