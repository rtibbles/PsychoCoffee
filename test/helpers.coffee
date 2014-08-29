require('initialize')

document.write('<div id="backbone-testing"></div>')
PsychoCoffee.rootElement = '#backbone-testing'

module 'Integration tests',
    setup: ->

    teardown: ->
