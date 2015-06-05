gulp   = require 'gulp'
wrench = require 'wrench'

wrench.readdirSyncRecursive('./tasks')
  .filter (file) -> /\.(js|coffee)$/i.test file
  .map    (file) -> require "./tasks/#{file}"

gulp.task 'default', ['test', 'clean', 'build'], -> undefined
