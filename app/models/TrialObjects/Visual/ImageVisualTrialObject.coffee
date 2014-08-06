'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model
    defaults: ->
        _.extend
            imageFile: "/images/test.png"
        ,
            super

module.exports =
    Model: Model