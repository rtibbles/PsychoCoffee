'use strict'

module.exports = class ExperimentModel extends Backbone.Model
    # title: DS.attr 'string'
    # trials: DS.hasMany 'trial'


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