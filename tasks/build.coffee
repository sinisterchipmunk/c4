gulp = require 'gulp'
fs = require 'fs'

compile = ->
  path = require 'path'
  dist = path.join __dirname, '../dist'
  tmp  = path.join __dirname, '../tmp'
  fs.mkdir dist, -> undefined
  fs.mkdir tmp,  -> undefined
  child_process = require 'child_process'

  # building directly to dist/ causes watchers (see test.coffee) to fire
  # before the file is completely written, causing ParseErrors. So build to
  # tmp, then move.

  child = child_process.spawn 'browserify', [
    '-t', 'coffeeify'
    #'-u', '**/jquery/**'
    '--extension', '.coffee'
    path.join("src/c4.coffee")
    '-o', path.join(tmp, 'c4.js')
    '-d'
  ]

  child.stderr.on 'data', (data) -> console.log data.toString()
  child.stdout.on 'data', (data) -> console.log data.toString()

  child.on 'exit', (code) ->
    process.exitCode = code
    child_process.spawn 'mv', [
      path.join tmp, 'c4.js'
      path.join dist, 'c4.js'
    ]

gulp.task 'build', compile

module.exports = ->
exports.compile = compile
