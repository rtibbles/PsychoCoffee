'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model

    objectOptions: ->
        super().concat([
            name: "height"
            type: "number"
        ,
            name: "x"
            default: 0
            type: "number"
        ,
            name: "originX"
            default: "center"
            type: "options"
            options: ["center", "left", "right"]
        ,
            name: "originY"
            default: "center"
            type: "options"
            options: ["center", "top", "bottom"]
        ,
            name: "y"
            default: 0
            type: "number"
        ,
            name: "width"
            type: "number"
        ])

module.exports =
    Model: Model