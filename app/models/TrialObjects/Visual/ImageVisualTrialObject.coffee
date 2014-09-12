'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    requiredParameters: ->
        [
            name: "file"
            default: ""
            type: "File"
            extensions: ["png", "jpg", "gif"]
        ]

    name: ->
        @get("name") or @get("file")

module.exports =
    Model: Model
    Type: "image"