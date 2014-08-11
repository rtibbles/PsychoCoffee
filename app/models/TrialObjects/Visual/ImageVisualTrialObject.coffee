'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    name: ->
        @get("name") or @get("file")

module.exports =
    Model: Model
    Type: "image"