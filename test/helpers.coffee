require('initialize')

document.write('<div id="backbone-testing"></div>')
PsychoCoffee.rootElement = '#backbone-testing'
PsychoCoffee.setupForTesting()
PsychoCoffee.injectTestHelpers()

module 'Integration tests',
    setup: ->

    teardown: ->
        PsychoCoffee.reset()
