module.exports = (config) ->
  configuration =
    autoWatch: false
    frameworks: ['mocha', 'chai']
    browsers: ['PhantomJS']
    plugins: [
      'karma-phantomjs-launcher'
      'karma-mocha'
      'karma-coffee-preprocessor'
      'karma-chai'
    ]
    preprocessors:
      '**/*.coffee': ['coffee']
    coffeePreprocessor:
      # options passed to the coffee compiler
      options:
        bare: true
        sourceMap: true
      # transforming the filenames
      transformPath: (path) ->
        return path.replace /\.coffee$/, '.js'

  # This block is needed to execute Chrome on Travis
  # If you ever plan to use Chrome and Travis, you can keep it
  # If not, you can safely remove it
  # https://github.com/karma-runner/karma/issues/1144#issuecomment-53633076
  if configuration.browsers[0] is 'Chrome' and process.env.TRAVIS
    configuration.customLaunchers =
      'chrome-travis-ci':
        base: 'Chrome',
        flags: ['--no-sandbox']

    configuration.browsers = ['chrome-travis-ci']

  config.set configuration
