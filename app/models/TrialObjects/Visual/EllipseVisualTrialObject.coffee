'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    objectOptions: ->
        super().concat(
            [
                    name: "ry"
                    default: 24
                    type: "number"
                ,
                    name: "ry"
                    default: 24
                    type: "number"
            ])

module.exports =
    Model: Model
    Type: "text"