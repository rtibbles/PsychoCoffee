'use strict'

# Karma configuration
# Generated on Fri Sep 06 2013 16:44:32 GMT-0400 (AST)

module.exports = (config) =>
  config.set

    # base path, that will be used to resolve files and exclude
    basePath: ''


    # frameworks to use
    frameworks: ['qunit', 'benchmark']


    # list of files / patterns to load in the browser
    files: [
      'public/javascripts/vendor.js',
      'public/javascripts/app.js',
      'test/helpers.js',
      'test/**/*_test.js',
      'test/**/*_test.coffee'
    ],


    # list of files to exclude
    exclude: [

    ],


    # test results reporter to use
    # possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress']#, 'benchmark']


    # web server port
    port: 9876


    # enable / disable colors in the output (reporters and logs)
    colors: true


    # level of logging
    # possible values:
    # config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN ||
    # config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_DEBUG


    # enable / disable watching file and executing
    # tests whenever any file changes
    autoWatch: true


    # Start these browsers, currently available:
    # - Chrome
    # - ChromeCanary
    # - Firefox
    # - Opera
    # - Safari (only Mac)
    # - PhantomJS
    # - IE (only Windows)
    browsers: ['PhantomJS']


    # If browser does not capture in given timeout [ms], kill it
    captureTimeout: 600000000


    # Continuous Integration mode
    # if true, it capture browsers, run tests and exit
    singleRun: false

    preprocessors:
        '**/*.coffee': 'coffee'