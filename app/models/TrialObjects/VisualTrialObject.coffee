'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model
    defaults: ->
        _.extend
            x: 320
            y: 400
            width: 100
            height: 100
            opacity: 1
        ,
            super

module.exports =
    Model: Model