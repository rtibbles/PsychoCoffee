'use strict'

Model = require('./Model')
TrialDataHandlerModel = require('./TrialDataHandlerModel')

module.exports = class ExperimentDataHandlerModel extends Model
    relations: [
        type: 'hasMany'
        key: 'trialdatahandlers'
        relatedModel: "TrialDataHandlerModel"
        reverseRelation:
            key: "experimentdatahandler"
    ]

# Required for Backbone Relational models extended using Coffeescript syntax
ExperimentDataHandlerModel.setup()