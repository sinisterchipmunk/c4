gulp = require 'gulp'

gulp.task 'clean', ->
  rmrf = require 'rimraf'
  rmrf require('path').join(__dirname, '../dist'), -> undefined

module.exports = ->
