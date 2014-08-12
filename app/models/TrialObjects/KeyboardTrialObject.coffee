'use strict'

TrialObject = require "../TrialObject"
Keys = require "utils/keys"

class Model extends TrialObject.Model

    defaults: ->
        _.extend
            keys: _.keys(Keys.Keys)

module.exports =
    Model: Model
    Type: "keyboard"