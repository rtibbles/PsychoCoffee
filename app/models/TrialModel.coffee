'use strict'

Model = require('./Model')
TrialObjectModel = require("./TrialObjectModel")

module.exports = class TrialModel extends Model
    relations: [
        type: 'hasMany'
        key: 'trialObjects'
        relatedModel: "TrialObjectModel"
        reverseRelation:
            key: "trial"
    ]
    # width: DS.attr 'number'
    # height: DS.attr 'number'

TrialModel.Data = [
    {
     id: 1
     experiment: 1
     width: 800
     height: 600
     trialobjects: [1]
    }
]

# Required for Backbone Relational models extended using Coffeescript syntax
TrialModel.setup()