'use strict'

TextVisualTrialObject = require '../TextVisualTrialObject'

class Model extends TextVisualTrialObject.Model

    objectOptions: ->
        super().concat(
            [
                    name: "justify"
                    default: "left"
                    type: "options"
                    options: ["left", "right", "center"]
            ])

    name: ->
        @get("name") or @get("text")

module.exports =
    Model: Model
    Type: "textbox"