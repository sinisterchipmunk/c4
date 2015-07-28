chokidar = require 'chokidar'
coffee = require 'coffee-script'
minimatch = require 'minimatch'
path = require 'path'
fs = require 'fs'
Concat = require 'concat-with-sourcemaps'
toffee = require 'toffee'

manifest = require path.join process.cwd(), 'config/manifest'
sources = {}

console.log 'watching files according to manifest', manifest

complete = ->

module.exports = (cb) ->
  complete = cb
  compile()

filetypes =
  js: (ext) -> ['coffee', 'js', 'html'].indexOf(ext) isnt -1

compilers =
  coffee: (filename, sourceCode) ->
    result = coffee.compile sourceCode,
      sourceMap: true
      filename: filename
      sourceFiles: [filename]
    code: result.js
    type: 'js'
    filename: filename
    source_map: result.v3SourceMap

  html: (filename, sourceCode) ->
    view = new toffee.view sourceCode,
      fileName: filename
      bundlePath: "/#{filename}"
      browserMode: true
      minimize: false
    javascript = view.toJavaScript()
    unless javascript
      javascript = view.error.getPrettyPrint().replace(/\n/g, "\\n")
      javascript = "toffee.templates['/#{filename}'] = {render: function() { return '#{javascript}'; }};"
    code: javascript
    type: 'js'
    filename: filename
    source_map: undefined

  js: (filename, sourceCode) ->
    code: sourceCode
    type: 'js'
    filename: filename
    source_map: undefined

postprocess = (results) ->
  # console.log 'postprocessing'

  concats =
    js: new Concat true, 'app.js', '\n'
  concats.js.add '__toffee', require('toffee/lib/view').getCommonHeadersJs()

  # concat them in the correct order
  for bundle in results
    if concats[bundle.type]
      concats[bundle.type].add bundle.filename, bundle.code, bundle.source_map
    else
      console.warn 'no postprocessor for file type', bundle.type

  for type, concat of concats
    concats[type] =
      code: concat.content
      map:  concat.sourceMap

  complete concats

  # # scrub roots from source maps
  # source_map = JSON.parse concat.sourceMap
  # for source, index in source_map.sources
  #   for root in manifest.roots
  #     if source.indexOf(root) is 0
  #       source_map.sources[index] = source[(root.length+1)..-1]
  #       break
  # concats.js =
  #   code: concat.content
  #   source_map: JSON.stringify source_map
  # callbacks.js? concats.js

filetype = (extension) ->
  for type, tester of filetypes
    return type if tester extension
  console.warn 'filetype not recognized for extension', extension
  null

relativize_filename = (filename) ->
  relative_filename = filename
  for root in manifest.roots
    if relative_filename.indexOf(root) is 0
      relative_filename = relative_filename[(root.length+1)..-1]
      break
  relative_filename

compile = ->
  results = []
  for filename, source of sources
    filename = relativize_filename filename
    handled = false
    # console.log 'compiling', filename
    for extension, compiler of compilers
      if new RegExp("#{extension}$").test filename
        results.push compiler filename, source
        handled = true
        break
    unless handled
      console.warn 'no suitable compiler found', filename
  postprocess results

recompileTimeout = null
recompile = ->
  clearTimeout recompileTimeout
  recompileTimeout = setTimeout compile, 50

read = (filename) ->
  ext = filename.substring filename.lastIndexOf('.') + 1, filename.length
  type = filetype ext
  return unless type

  # console.log 'filetype of', filename, 'is', type
  found = false
  for pattern in manifest.patterns[type]
    if pattern[0] is '!'
      unless minimatch filename, pattern
        found = false
        break
    else
      found = true if minimatch filename, pattern
  unless found
    # console.log 'rejecting file', filename, 'with pattern', pattern
    return

  # console.log 'reading file', filename

  fs.readFile filename, 'utf8', (err, code) ->
    throw err if err
    # console.log ' => ', code.length, ' bytes'
    sources[filename] = code
    recompile()


chokidar.watch('src/**/*').on 'all', (event, path) ->
  switch event
    when 'add', 'change' then read path
    when 'unlink'
      delete sources[path]
      recompile()
