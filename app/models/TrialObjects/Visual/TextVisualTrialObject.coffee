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

    name: ->
        @get("name") or @get("text")

module.exports =
    Model: Model
    Type: "text"