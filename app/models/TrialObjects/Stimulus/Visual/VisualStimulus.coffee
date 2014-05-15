'use strict'

Stimulus = require("../Stimulus")

module.exports = App.VisualStimulus = Stimulus.extend
    x: DS.attr 'number'
    y: DS.attr 'number'
    width: DS.attr 'number'
    height: DS.attr 'number'
    opacity: DS.attr 'number'
