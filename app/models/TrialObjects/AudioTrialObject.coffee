'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model

    requiredParameters: ->
        super().concat(
            [
                name: "file"
                default: ""
                type: "File"
                extensions: ["mp3"]
            ])

    name: ->
        @get("name") or @get("file")

module.exports =
    Model: Model
    Type: "Audio"