'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model

    name: ->
        @get("name") or @get("file")

module.exports =
    Model: Model
    Type: "audio"