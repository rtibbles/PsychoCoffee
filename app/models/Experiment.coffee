'use strict'

Base = require('./Base')
Trial = require('./Trial')

class Model extends Base.Model
    relations: [
        type: 'hasMany'
        key: 'trials'
        relatedModel: "Trial.Model"
        reverseRelation:
            key: "experiment"
    ]
    # title: DS.attr 'string'


# Dummy data for testing
Model.Data = [
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
Model.setup()

class Collection extends Base.Collection


module.exports =
    Model: Model
    Collection: Collection
