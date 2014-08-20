'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    objectOptions: ->
        super().concat(
            [
                    name: "rx"
                    default: 1
                    type: "number"
                ,
                    name: "ry"
                    default: 1
                    type: "number"
            ])

module.exports =
    Model: Model
    Type: "rectangle"