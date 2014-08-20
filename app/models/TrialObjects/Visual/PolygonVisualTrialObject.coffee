'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    requiredParameters: ->
        [
            name: "points"
            default: []
            type: "array"
            embedded-type: fabric.Point
        ]

module.exports =
    Model: Model
    Type: "text"