'use strict'

Base = require('./Base')
Trial = require('./Trial')

class Model extends Base.Model
    relations: [
        type: 'HasMany'
        key: 'trials'
        relatedModel: Trial.Model
        reverseRelation:
            key: "experiment"
    ]
    # title: DS.attr 'string'


# Dummy data for testing
Data = [
    {
     _id: 1
     title: 'Stroop'
     trials: [{_id: 1}]
    },
    {
     _id: 2
     title: '2AFC'
    },
    {
     _id: 3
     title: 'Other'
    }
]

# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Base.Collection


module.exports =
    Model: Model
    Collection: Collection
    Data: Data
