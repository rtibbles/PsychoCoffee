'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model
    defaults: ->
        _.extend
            text: ""
            super

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
                    default: "#FFFFFF"
                    type: "hex-colour"
            ])

    name: ->
        @get("name") or @get("text")

module.exports =
    Model: Model
    Type: "text"