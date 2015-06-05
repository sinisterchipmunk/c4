watch = require 'watch'
coffee = require 'coffee-script'
minimatch = require 'minimatch'
path = require 'path'
fs = require 'fs'
Concat = require 'concat-with-sourcemaps'
toffee = require 'toffee'

manifest = require path.join process.cwd(), 'config/manifest'

console.log 'watching files according to manifest', manifest

cache = {}
callbacks = {}
concats =
  js:
    code: ''
    source_map: ''
  css:
    code: ''
    source_map: ''
filenames =
  js: 'app.js'
  css: 'app.css'

module.exports = (opts) ->
  filenames.js  = opts.fn.js  if opts.fn?.js
  filenames.css = opts.fn.css if opts.fn?.css
  callbacks.js  = opts.cb.js  if opts.cb?.js
  callbacks.css = opts.cb.css if opts.cb?.css
  callbacks.js  concats.js
  callbacks.css concats.css

concatjs = (done) ->
  concat = new Concat true, filenames.js, '\n'
  headers = require('toffee/lib/view').getCommonHeadersJs()
  concat.add '__toffee', headers

  # concat them in the correct order
  for filename, entry of cache
    for pattern in manifest.js
      # handle 'ignore' directives - can minimatch be instructed to do this?
      if pattern[0] is '!'
        if minimatch filename, pattern[1..-1]
          break
        else continue
      if minimatch filename, pattern
        concat.add filename, entry.code, entry.source_map
        break
  # scrub roots from source maps
  source_map = JSON.parse concat.sourceMap
  for source, index in source_map.sources
    for root in manifest.roots
      if source.indexOf(root) is 0
        source_map.sources[index] = source[(root.length+1)..-1]
        break
  concats.js =
    code: concat.content
    source_map: JSON.stringify source_map
  callbacks.js? concats.js

to_compile = []
compile = (filename, stat, done) ->
  for pattern in manifest.js
    continue if pattern[0] is '!' # we'll handle that later
    if minimatch filename, pattern
      to_compile.push filename
      relative_filename = filename
      for root in manifest.roots
        if relative_filename.indexOf(root) is 0
          relative_filename = relative_filename[(root.length+1)..-1]
          break
      do (filename, relative_filename) ->
        fs.readFile filename, 'utf8', (err, code) ->
          throw err if err
          if /coffee$/.test filename
            compiled = coffee.compile code,
              sourceMap: true
              filename: filename
              sourceFiles: [relative_filename]
          else if /html$/.test filename
            view = new toffee.view code,
              fileName: filename
              bundlePath: relative_filename
              browserMode: true
              minimize: false
            compiled =
              code: view.toJavaScript()
              source_map: undefined
          else
            compiled =
              code: code
              v3SourceMap: undefined
          cache[filename] =
            mtime: stat.mtime
            code: compiled.js || compiled.code
            source_map: compiled.v3SourceMap
            filename: relative_filename
          to_compile.shift()
          done() if to_compile.length is 0
      return

watch.createMonitor '.', (monitor) ->
  timeout = null

  for file, stat of monitor.files
    continue if stat.isDirectory()
    unless cache[file]?.mtime >= stat.mtime
      compile file, stat, ->
        clearTimeout timeout
        timeout = setTimeout concatjs, 50

  monitor.on 'created', (f, stat) ->
    compile f, stat, concatjs unless cache[f]?.mtime >= stat.mtime

  monitor.on 'changed', (f, curStat, prevStat) ->
    compile f, curStat, concatjs unless cache[f]?.mtime >= stat.mtime

  monitor.on 'removed', (f, stat) ->
    remove f, concatjs
  