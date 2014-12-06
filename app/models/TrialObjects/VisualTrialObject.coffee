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
            name: "scaleY"
            default: 1
            type: "Number"
        ,
            name: "x"
            default: 200
            type: "Number"
            alias: "left"
        ,
            name: "opacity"
            default: 1
            type: "Number"
        ,
            name: "y"
            default: 200
            type: "Number"
            alias: "top"
        ,
            name: "scaleX"
            default: 1
            type: "Number"
        ])

    fixedItems: ->
        super().concat([
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
            ])
    
    triggers: ->
        super().concat([
                "click"
            ])

module.exports =
    Model: Model