'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model

    objectOptions: ->
        [
            name: "height"
            type: "number"
        ,
            name: "left"
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
            options: ["center", "left", "right"]
        ,
            name: "top"
            default: 0
            type: "number"
        ,
            name: "width"
            type: "number"
        ]

module.exports =
    Model: Model