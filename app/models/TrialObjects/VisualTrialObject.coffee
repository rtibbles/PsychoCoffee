'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model

    objectOptions: ->
        super().concat([
            name: "angle"
            default: 0
            type: "number"
        ,
            name: "fill"
            default: "#000000"
            type: "hex-colour"
        ,
            name: "height"
            type: "number"
        ,
            name: "left"
            default: 0
            type: "number"
        ,
            name: "opacity"
            default: 1
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
        ])

module.exports =
    Model: Model