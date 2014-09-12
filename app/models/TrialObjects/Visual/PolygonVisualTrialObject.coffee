'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    requiredParameters: ->
        [
            name: "points"
            default: []
            type: "Array"
            embedded_type: fabric.Point
        ]

module.exports =
    Model: Model
    Type: "polygon"