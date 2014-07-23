'use strict'

VisualTrialObject = require("./VisualTrialObject")

class Model extends VisualTrialObject.Model
    # text: DS.attr 'string'
    # fontSize: DS.attr 'number'
    # fontFamily: DS.attr 'string'
    # fontStyle: DS.attr 'string'

Model.Data = [
    {
     id: 1
     type: "TextVisualTrialObject"
     text: "hello"
     fontSize: 24
     fontFamily: "arial"
     fontStyle: "normal"
     trial: 1
     delay: 0
     duration: 10
     triggers: []
     x: 400
     y: 400
     width: 100
     height: 100
     opacity: 0.5
    }
]

module.exports =
    Model: Model