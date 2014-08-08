'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model
    defaults: ->
        _.extend
            text: "hello"
            fontSize: 24
            fontFamily: "arial"
            fontStyle: "normal"
            super

module.exports =
    Model: Model