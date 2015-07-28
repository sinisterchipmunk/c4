gulp = require 'gulp'

patterns = ->
  [
    require('c4/cli/paths').dist
    'test-helper.coffee'
    'src/modules/**/*.html'
    'src/**/*.coffee'
  ]

done = (code) ->
  process.exit code

gulp.task 'test', ->
  karma = require 'karma'
  karma.server.start
    configFile: "#{__dirname}/../karma.conf.coffee"
    files: patterns()
    singleRun: true
    autoWatch: false
  , done

gulp.task 'watch', ->
  path = require 'path'
  watch = require 'watch'

  watch.createMonitor path.join(__dirname, '../src'), (monitor) ->
    timeout = null
    monitor.on 'created', (f, stat) -> gulp.start 'build'
    monitor.on 'changed', (f, stat) -> gulp.start 'build'
    monitor.on 'removed', (f, stat) -> gulp.start 'build'

  karma = require 'karma'
  karma.server.start
    configFile: "#{__dirname}/../karma.conf.coffee"
    files: patterns()
    singleRun: false
    autoWatch: true
  , done
