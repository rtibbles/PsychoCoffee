'use strict'

VisualTrialObjectModel = require("./VisualTrialObjectModel")

module.exports = class TextVisualTrialObjectModel extends VisualTrialObjectModel
    # text: DS.attr 'string'
    # fontSize: DS.attr 'number'
    # fontFamily: DS.attr 'string'
    # fontStyle: DS.attr 'string'

TextVisualTrialObjectModel.Data = [
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

# Required for Backbone Relational models extended using Coffeescript syntax
# TextVisualTrialObjectModel.setup()