require('initialize')

document.write('<div id="backbone-testing"></div>')
PsychoCoffee.rootElement = '#backbone-testing'

testCount = 0
qunitTest = QUnit.test
QUnit.test = window.test = ->
    testCount += 1
    qunitTest.apply(this, arguments)

QUnit.begin (args) ->
    args.totalTests = testCount