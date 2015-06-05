gulp = require 'gulp'
path = require 'path'
colors = require 'colors'

tests = []

###
  Functions to set up and run a minimal test suite. Didn't feel like bringing
  in a whole framework for just bin tests.
###
test = (desc, cb) ->
  tests.push [desc, cb, false]

wip = (desc, cb) ->
  tests.push [desc, cb, true]

runTests = ->
  rmrf = require 'rimraf'
  fs = require 'fs'
  for set, i in tests
    [desc, cb, is_wip] = [set...]
    # Run each test in its own clean directory.
    tmp = path.join __dirname, "../tmp/test/#{i}"
    do (desc, cb, is_wip, tmp) ->
      rmrf tmp, (e) ->
        throw new Error e if e
        fs.mkdir tmp, (e) ->
          throw new Error e if e
          process.chdir tmp
          test_run =
            path: tmp
            errs: []
            chdir: (parts...) ->
              process.chdir path.join @path, parts.join '/'
              @path = process.cwd()
            blocked: (msg = 'unspecified') ->
              @blocked_by = msg
              @done()
            done: ->
              if @blocked_by
                console.log '?'.yellow, "BLOCKED".yellow, desc.yellow
                console.log '    Reason:'.yellow, @blocked_by.red
              else if @errs.length
                process.exitCode = 1
                console.log 'X'.red, desc.red
                console.log '    ( ran in:', @path, ')'
                for err in @errs
                  console.log '     ', err.message.red
                  # console.log err.stack.red
              else
                console.log '√'.green, desc.green
          for name, assertion of exports
            test_run[name] = assertion
          if is_wip
            test_run.blocked 'work-in-progress'
          else
            cb test_run

###
  Assertions.
###
exports.eq = (a, b) ->
  if a isnt b
    @errs.push new Error "expected #{JSON.stringify b} to equal #{JSON.stringify a}"

exports.neq = (a, b) ->
  if a is b
    @errs.push new Error "expected #{JSON.stringify b} not to equal #{JSON.stringify a}"

exports.file = (a) ->
  fs = require 'fs'
  a = path.join @path, a
  try
    unless fs.statSync(a).isFile()
      @errs.push new Error "expected path `#{JSON.stringify a}` to be a file, but it is not"
  catch e
    @errs.push new Error "expected path `#{JSON.stringify a}` to be a file, but it does not exist"

exports.dir = (a) ->
  fs = require 'fs'
  a = path.join @path, a
  try
    unless fs.statSync(a).isDirectory()
      @errs.push new Error "expected path `#{JSON.stringify a}` to be a directory, but it is not"
  catch e
    @errs.push new Error "expected path `#{JSON.stringify a}` to be a directory, but it does not exist"

###
  Run the `c4` CLI with some args.
###
exec = (cmd, args..., opts) ->
  {spawn} = require 'child_process'
  child = spawn cmd, args
  [stdout, stderr] = ['', '']
  child.stdin.end opts.stdin || ''
  child.stdout.on 'data', (data) -> stdout += data.toString()
  child.stderr.on 'data', (data) -> stderr += data.toString()
  child.on 'exit', (code) ->
    opts.done? code: code, stdout: stdout, stderr: stderr

c4 = (args..., opts) ->
  exec path.join(__dirname, '../bin/c4'), args..., opts

###
  Actual Tests!
###
defineTests = ->
  test '`c4` should output usage', (assert) ->
    c4 done: (result) ->
      assert.eq   0, result.code
      assert.eq  '', result.stderr
      assert.neq '', result.stdout
      assert.done()
  wip '`c4 invalidArg` should output usage', (assert) ->
    c4 'invalidArg', done: (result) ->
      assert.eq   0, result.code
      assert.eq  '', result.stderr
      assert.neq '', result.stdout
      assert.done()
  test '`c4 new` should output usage', (assert) ->
    c4 'new', done: (result) ->
      assert.eq   0, result.code
      assert.eq  '', result.stderr
      assert.neq '', result.stdout
      assert.done()
  wip '`c4 new invalidArg` should output usage', (assert) ->
    c4 'new', 'invalidArg', done: (result) ->
      assert.eq   0, result.code
      assert.eq  '', result.stderr
      assert.neq '', result.stdout
      assert.done()
  test '`c4 new app` should output usage', (assert) ->
    c4 'new', 'app', done: (result) ->
      assert.eq   0, result.code
      assert.eq  '', result.stderr
      assert.neq '', result.stdout
      assert.done()
  test '`c4 new app app-name` should generate app', (assert) ->
    c4 'new', 'app', 'app-name', done: (result) ->
      assert.eq    0, result.code
      assert.eq   '', result.stderr
      assert.neq  '', result.stdout
      assert.dir  'app-name'
      assert.file 'app-name/config/manifest.coffee'
      assert.file 'app-name/src/index.html'
      assert.file 'app-name/tasks/build.coffee'
      assert.file 'app-name/tasks/test.coffee'
      assert.file 'app-name/tasks/clean.coffee'
      assert.file 'app-name/gulpfile.coffee'
      assert.file 'app-name/karma.conf.coffee'
      assert.file 'app-name/test-helper.coffee'
      assert.done()
  test '`c4 new module` should output usage', (assert) ->
    c4 'new', 'app', 'app-name', done: (result) ->
      return assert.blocked 'app generation failed' if result.code isnt 0
      assert.chdir 'app-name'
      c4 'new', 'module', done: (result) ->
        assert.eq    0, result.code
        assert.eq   '', result.stderr
        assert.neq  '', result.stdout
        assert.done()
  test '`c4 new module mod-name` should generate module', (assert) ->
    c4 'new', 'app', 'app-name', done: (result) ->
      return assert.blocked 'app generation failed' if result.code isnt 0
      assert.chdir 'app-name'
      c4 'new', 'module', 'mod-name', done: (result) ->
        assert.eq    0, result.code
        assert.eq   '', result.stderr
        assert.neq  '', result.stdout
        assert.dir  'src/modules/mod-name/services'
        assert.dir  'src/modules/mod-name/views'
        assert.dir  'src/modules/mod-name/specs/services'
        assert.dir  'src/modules/mod-name/specs/views'
        assert.file 'src/modules/mod-name/views/index.html'
        assert.done()
  test '`c4 new module mod-name -s sname` should generate module with services', (assert) ->
    c4 'new', 'app', 'app-name', done: (result) ->
      return assert.blocked 'app generation failed' if result.code isnt 0
      assert.chdir 'app-name'
      c4 'new', 'module', 'mod-name', '-s', 'sname', done: (result) ->
        assert.eq    0, result.code
        assert.eq   '', result.stderr
        assert.neq  '', result.stdout
        assert.file 'src/modules/mod-name/services/sname.coffee'
        assert.dir  'src/modules/mod-name/views'
        assert.file 'src/modules/mod-name/specs/services/sname.spec.coffee'
        assert.dir  'src/modules/mod-name/specs/views'
        assert.file 'src/modules/mod-name/views/index.html'
        assert.done()
  test '`c4 new module mod-name -v vname` should generate module with views', (assert) ->
    c4 'new', 'app', 'app-name', done: (result) ->
      return assert.blocked 'app generation failed' if result.code isnt 0
      assert.chdir 'app-name'
      c4 'new', 'module', 'mod-name', '-v', 'vname', done: (result) ->
        assert.eq    0, result.code
        assert.eq   '', result.stderr
        assert.neq  '', result.stdout
        assert.dir  'src/modules/mod-name/services'
        assert.file 'src/modules/mod-name/views/vname.coffee'
        assert.dir  'src/modules/mod-name/specs/services'
        assert.file 'src/modules/mod-name/specs/views/vname.spec.coffee'
        assert.file 'src/modules/mod-name/views/vname.html'
        assert.file 'src/modules/mod-name/views/index.html'
        assert.done()
  test '`c4 new module mod-name -s sname -v vname` should generate module with services and views', (assert) ->
    c4 'new', 'app', 'app-name', done: (result) ->
      return assert.blocked 'app generation failed' if result.code isnt 0
      assert.chdir 'app-name'
      c4 'new', 'module', 'mod-name', '-s', 'sname', '-v', 'vname', done: (result) ->
        assert.eq    0, result.code
        assert.eq   '', result.stderr
        assert.neq  '', result.stdout
        assert.file 'src/modules/mod-name/services/sname.coffee'
        assert.file 'src/modules/mod-name/views/vname.coffee'
        assert.file 'src/modules/mod-name/specs/services/sname.spec.coffee'
        assert.file 'src/modules/mod-name/specs/views/vname.spec.coffee'
        assert.file 'src/modules/mod-name/views/vname.html'
        assert.file 'src/modules/mod-name/views/index.html'
        assert.done()
  test 'default module unit tests should pass', (assert) ->
    c4 'new', 'app', 'app-name', done: (result) ->
      return assert.blocked 'app generation failed' if result.code isnt 0
      assert.chdir 'app-name'
      c4 'new', 'module', 'mod-name', '-s', 'sname', '-v', 'vname', done: (result) ->
        return assert.blocked 'module generation failed' if result.code isnt 0
        process.chdir assert.path # HACK
        exec 'gulp', 'test', done: (result) ->
          assert.eq 0, result.code
          assert.done()
          if result.code isnt 0
            console.log result.stderr
            console.log result.stdout
gulp.task 'bintest', ->
  defineTests()
  runTests()

module.exports = ->
