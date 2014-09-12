'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model

    objectOptions: ->
        super().concat([
            name: "angle"
            default: 0
            type: "Number"
        ,
            name: "fill"
            default: "#000000"
            type: "Colour"
        ,
            name: "height"
            type: "Number"
        ,
            name: "x"
            default: 0
            type: "Number"
            alias: "left"
        ,
            name: "opacity"
            default: 1
            type: "Number"
        ,
            name: "originX"
            default: "center"
            type: "String"
            options: [
                ["center", "CENTER"]
                ["left", "LEFT"]
                ["right", "RIGHT"]
            ]
        ,
            name: "originY"
            default: "center"
            type: "String"
            options: [
                ["center", "CENTER"]
                ["top", "TOP"]
                ["bottom", "BOTTOM"]
            ]
        ,
            name: "y"
            default: 0
            type: "Number"
            alias: "top"
        ,
            name: "width"
            type: "Number"
        ])

module.exports =
    Model: Model