'use strict'

VisualStimulus = require("./VisualStimulus")

module.exports = App.TextVisualStimulus = VisualStimulus.extend
    text: DS.attr 'string'
    fontSize: DS.attr 'number'
    fontFamily: DS.attr 'string'
    fontStyle: DS.attr 'string'

