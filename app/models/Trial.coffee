'use strict'

Base = require('./Base')
TrialObject = require("./TrialObject")

class Model extends Base.Model
    relations: [
        type: 'HasMany'
        key: 'trialObjects'
        relatedModel: TrialObject.Model
        reverseRelation:
            key: "trial"
    ]
    # width: DS.attr 'number'
    # height: DS.attr 'number'

Data = [
    {
     _id: 1
     experiment: 1
     width: 800
     height: 600
     trialobjects: [1]
    }
]

# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Base.Collection

module.exports =
    Model: Model
    Collection: Collection
    Data: Data