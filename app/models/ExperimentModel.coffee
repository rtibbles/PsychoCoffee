'use strict'

Model = require('./Model')
TrialModel = require('./TrialModel')

module.exports = class ExperimentModel extends Model
    relations: [
        type: 'hasMany'
        key: 'trials'
        relatedModel: "TrialModel"
        reverseRelation:
            key: "experiment"
    ]
    # title: DS.attr 'string'


# Dummy data for testing
ExperimentModel.Data = [
    {
     id: 1
     title: 'Stroop'
     trials: [1]
    },
    {
     id: 2
     title: '2AFC'
    },
    {
     id: 3
     title: 'Other'
    }
]

# Required for Backbone Relational models extended using Coffeescript syntax
ExperimentModel.setup()