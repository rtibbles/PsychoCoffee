require('initialize')

document.write('<div id="backbone-testing"></div>')
App.rootElement = '#backbone-testing'
App.setupForTesting()
App.injectTestHelpers()

module 'Integration tests',
    setup: ->

    teardown: ->
        App.reset()
