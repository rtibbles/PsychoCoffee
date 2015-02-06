'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    objectOptions: ->
        super().concat(
            [
                    name: "rx"
                    default: 24
                    type: "Number"
                ,
                    name: "ry"
                    default: 24
                    type: "Number"
            ])

module.exports =
    Model: Model
    Type: "Ellipse"