'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model
    defaults: ->
        defaults = {}
        for option in @objectOptions()
            defaults[option.name] = option.default
        _.extend defaults, super

    objectOptions: ->
        [
            name: "angle"
            default: 0
            type: "number"
        ,
            name: "fill"
            default: "#000000"
            type: "hex-colour"
        ,
            name: "height"
            default: 0
            type: "number"
        ,
            name: "left"
            default: 0
            type: "number"
        ,
            name: "opacity"
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
            default: 0
            type: "number"
        ]

    returnOptions: ->
        options = {}
        for option in @objectOptions()
            options[option.name] = @get option.name
        return options

module.exports =
    Model: Model