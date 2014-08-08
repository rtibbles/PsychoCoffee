'use strict'

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model
    defaults: ->
        _.extend
            angle: 0
            fill: "#000000"
            height: 0
            left: 0
            opacity: 1
            originX: "center"
            originY: "center"
            top: 0
            width: 0
            super

module.exports =
    Model: Model