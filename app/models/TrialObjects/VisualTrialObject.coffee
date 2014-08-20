'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model
    defaults: ->
        defaults = {}
        for option in @objectOptions()
            if option.default?
                defaults[option.name] = option.default
        for parameter in @requiredParameters()
            defaults[parameter.name] = parameter.default
        _.extend defaults, super

    requiredParameters: ->
        # Lists all parameters needed to initialize object
        # Assumes listed in order that they appear in args
        []

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
        ]

    returnRequired: ->
        required = []
        for parameter in @requiredParameters()
            required.push @get(parameter.name)
        return required

    returnOptions: ->
        options = {}
        for option in @objectOptions()
            if @get(option.name)?
                options[option.name] = @get option.name
        return options

module.exports =
    Model: Model