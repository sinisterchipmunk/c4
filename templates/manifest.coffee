###
  The manifest is used to list project sources in the order they should
  appear in the compiled JavaScript and CSS files. Glob patterns are
  supported, and the default directive assumes that the order in which
  files are loaded does not matter and just loads all files as they are
  encountered.

  If you need a file to be loaded first, just place a path to it first in
  the array.
###
exports.patterns =
  js: [
    '!src/**/specs/**/*'
    'src/**/*.{js,coffee}'
    'src/modules/**/*.html'
  ]

  css: [
    'src/**/*.{css,scss}'
  ]

###
  Roots are path prefixes included in the above globbing patterns that should
  be stripped out of a path during sourcemap generation.

  When a browser evaluates a source map, it also requests the source of the
  file(s) in question. To do this, the source code must be made available by
  the web server. The `roots` option specifies a list of root paths which are
  all equivalent to `/` to the web server -- that is, the file system path to
  the document root, relative to the current working directory.

  For example, if you have a file in `src/example.coffee` then the compiled
  `/src.js` will contain a source map with a reference to `example.coffee` in
  it, so `/example.coffee` must be made available by the web server. In this
  example, `src` is the document root and it is not intended to be exposed.
###
exports.roots = [
  'src'
]
