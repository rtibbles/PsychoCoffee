'use strict'

HTMLTrialObject = require("../HTMLTrialObject")

class Model extends HTMLTrialObject.Model

    requiredParameters: ->
        [
            name: "prefill"
            default: ""
            type: "String"
        ,
            name: "prompt"
            default: ""
            type: "String"
        ]

    objectOptions: ->
        super().concat(
            [
                    name: "fontSize"
                    default: 24
                    type: "Number"
                ,
                    name: "fontFamily"
                    default: "arial"
                    type: "String"
                ,
                    name: "fontStyle"
                    default: "normal"
                    type: "String"
                ,
                    name: "backgroundColor"
                    default: ""
                    type: "Colour"
            ])

    name: ->
        @get("name") or @get("text")

module.exports =
    Model: Model
    Type: "text-input"