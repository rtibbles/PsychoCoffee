'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model


    requiredParameters: ->
        [
            name: "text"
            default: ""
            type: "string"
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
    Type: "text"