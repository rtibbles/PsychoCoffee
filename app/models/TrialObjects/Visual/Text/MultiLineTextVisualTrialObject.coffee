'use strict'

TextVisualTrialObject = require '../TextVisualTrialObject'
wrapCanvasText = require 'utils/wrapCanvasText'

class Model extends TextVisualTrialObject.Model

    objectOptions: ->
        super().concat(
            [
                    name: "maxWidth"
                    default: 100
                    type: "number"
                ,
                    name: "maxHeight"
                    default: 100
                    type: "number"
                ,
                    name: "justify"
                    default: "left"
                    type: "options"
                    options: ["left", "right", "center"]
            ])

    name: ->
        @get("name") or @get("text")

    allParameters: ->
        parameters = super()
        parameters["text"] = wrapCanvasText(parameters["text"])
        return parameters

    returnRequired: ->
        required = super()
        required[0] = wrapCanvasText(required[0])
        return required

module.exports =
    Model: Model
    Type: "textbox"