'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model


    requiredParameters: ->
        super().concat(
            [
                name: "text"
                default: " "
                type: "String"
            ])

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
                    default: "#FFFFFF"
                    type: "Colour"
                ,
                    name: "justify"
                    default: "left"
                    type: "String"
                    options: [
                        ["left", "left"]
                        ["right", "right"]
                        ["center", "center"]
                    ]
            ])

    name: ->
        @get("name") or @get("text")

module.exports =
    Model: Model
    Type: "Text"