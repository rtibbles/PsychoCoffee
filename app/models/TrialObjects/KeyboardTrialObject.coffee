'use strict'

TrialObject = require "../TrialObject"
Keys = require "utils/keys"

class Model extends TrialObject.Model

    defaults: ->
        _.extend
            keys: _.keys(Keys.Keys)
            super

    triggers: ->
        super().concat([
                name: "keypress"
                arguments: ["key", "shiftKey"]
            ])

module.exports =
    Model: Model
    Type: "Keyboard"