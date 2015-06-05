fs = require 'fs'
path = require 'path'
toffee = require 'toffee'

# default config
config =
  base_path: path.join __dirname, '../../../templates'

###
  Function exposed to allow overriding of config
###
exports.config = (opts) ->
  for key, val of opts
    config[key] = val
  true

examined = {}
exports.directory = (dir, done, options = {}) ->
  # dir can be an array of ['a','b','c'], which should be treated as a/b/c,
  # and created recursively.
  if typeof dir isnt 'string'
    return done?() if dir.length is 0
    dir0 = dir.shift()
    dir0 = path.join options.prefix, dir0 if options.prefix
    recurse = -> exports.directory dir, done, prefix: dir0
    exports.directory dir0, recurse
    return
  # if dir is just a string, check if it exists and create if it doesn't.
  fs.lstat dir, (err, stats) ->
    if !err && stats?.isDirectory()
      console.log "exists    #{dir}" unless examined[dir]
      examined[dir] = true
      done?()
    else
      fs.mkdir dir, (err) ->
        throw err if err and err.code isnt 'EEXIST'
        console.log "directory #{dir}"
        examined[dir] = true
        done?()

exports.template = (src, dst, context = {}) ->
  done = context.done
  delete context.done
  template_path = path.join config.base_path, src
  fs.readFile template_path, 'utf8', (err, template) ->
    throw err if err
    view = new toffee.view template
    [err, res] = view.run context
    throw err if err
    # TODO check file exists, prompt to replace
    fs.writeFile dst, res, 'utf8', (err) ->
      throw err if err
      console.log "template  #{dst}"
      done?()

exports.file = (src, dst, options = {}) ->
  template_path = path.join config.base_path, src
  fs.readFile template_path, 'utf8', (err, template) ->
    throw err if err
    # TODO check file exists, prompt to replace
    fs.writeFile dst, template, 'utf8', (err) ->
      throw err if err
      console.log "template  #{dst}"
      options.done?()
