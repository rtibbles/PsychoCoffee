'use strict'

VisualTrialObject = require("../VisualTrialObject")

class Model extends VisualTrialObject.Model

    fileKey: "image"
    object: Image
    objectFileKey: "src"

    defaults: ->
        _.extend
            file: "/images/test.png"
        ,
            super

module.exports =
    Model: Model