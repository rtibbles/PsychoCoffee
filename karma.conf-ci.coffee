'use strict'

# Karma configuration
# Generated on Fri Sep 06 2013 16:44:32 GMT-0400 (AST)

customLaunchers =
    sl_chrome:
        base: 'SauceLabs'
        browserName: 'chrome'
        platform: 'Windows 7'
        version: '35'

    sl_firefox:
        base: 'SauceLabs'
        browserName: 'firefox'
        version: '30'

    # sl_ios_safari:
    #     base: 'SauceLabs'
    #     browserName: 'iphone'
    #     platform: 'OS X 10.9'
    #     version: '7.1'

    sl_ie_11:
        base: 'SauceLabs'
        browserName: 'internet explorer'
        platform: 'Windows 8.1'
        version: '11'

    # sl_chrome_android:
    #     base: 'SauceLabs'
    #     browserName: 'android chrome'
    #     platform: 'Linux'
    #     deviceName: 'Android'
    #     version: '4.4'
    #     "device-orientation": 'landscape'


module.exports = (config) =>
  config.set

    # base path, that will be used to resolve files and exclude
    basePath: ''


    # frameworks to use
    frameworks: ['qunit', 'benchmark', 'sinon']


    # list of files / patterns to load in the browser
    files: [
      'public/js/vendor.js',
      'public/js/app.js',
      'test/helpers.coffee',
      'test/**/*_test.js',
      'test/**/*_test.coffee'
    ],


    # list of files to exclude
    exclude: [

    ],


    # test results reporter to use
    # possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress', 'saucelabs']


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

    sauceLabs:
        testName: 'PsychoCoffee Unit and Integration Tests'

    customLaunchers: customLaunchers

    browsers: Object.keys(customLaunchers)
    
    singleRun: true

    # If browser does not capture in given timeout [ms], kill it
    captureTimeout: 100000

    preprocessors:
        '**/*.coffee': 'coffee'