'use strict'

HTMLTrialObject = require("../HTMLTrialObject")

class Model extends HTMLTrialObject.Model

    requiredParameters: ->
        [
            name: "prefill"
            default: ""
            type: "string"
        ,
            name: "prompt"
            default: ""
            type: "string"
        ]

    objectOptions: ->
        super().concat(
            [
                    name: "fontSize"
                    default: 24
                    type: "number"
                ,
                    name: "fontFamily"
                    default: "arial"
                    type: "string"
                ,
                    name: "fontStyle"
                    default: "normal"
                    type: "string"
                ,
                    name: "backgroundColor"
                    default: ""
                    type: "hex-colour"
            ])

    name: ->
        @get("name") or @get("text")

module.exports =
    Model: Model
    Type: "text-input"