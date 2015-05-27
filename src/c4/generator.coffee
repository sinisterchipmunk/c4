fs = require 'fs'
path = require 'path'
toffee = require 'toffee'

examined = {}
exports.directory = (dir, done, options = {}) ->
  if typeof dir isnt 'string'
    return done?() if dir.length is 0
    dir0 = dir.shift()
    dir0 = path.join options.prefix, dir0 if options.prefix
    recurse = -> exports.directory dir, done, prefix: dir0
    exports.directory dir0, recurse
    return
  fs.lstat dir, (err, stats) ->
    if !err && stats?.isDirectory()
      console.log "exists    #{dir}" unless examined[dir]
      examined[dir] = true
      done?()
    else
      fs.mkdir dir, (err) ->
        throw err if err
        console.log "directory #{dir}"
        examined[dir] = true
        done?()

exports.template = (src, dst, context = {}) ->
  done = context.done
  delete context.done
  template_path = path.join __dirname, '../../templates', src
  fs.readFile template_path, 'utf8', (err, template) ->
    view = new toffee.view template
    [err, res] = view.run context
    throw err if err
    # TODO check file exists
    fs.writeFile dst, res, 'utf8', (err) ->
      throw err if err
      console.log "template  #{dst}"
      done
