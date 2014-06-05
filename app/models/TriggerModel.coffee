'use strict'

Model = require('./Model')
TrialObjectModel = require('./TrialObjectModel')

module.exports = class TriggerModel extends Model
    relations: [
        type: 'hasOne'
        key: 'source'
        relatedModel: "TrialObjectModel"
    ,
        type: 'hasOne'
        key: 'target'
        relatedModel: "TrialObjectModel"
    ]
    # listenEvent: "string"
    # triggerEvent: "string"


# Required for Backbone Relational models extended using Coffeescript syntax
TriggerModel.setup()