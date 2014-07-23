'use strict'

Base = require('./Base')
TrialEventLog = require('./TrialEventLog')

class Model extends Base.Model
    relations: [
        type: 'hasMany'
        key: 'trialeventlogs'
        relatedModel: "TrialEventLog.Model"
        includeInJSON: true
        reverseRelation:
            key: "trialdatahandler"
    ]

# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Base.Collection

module.exports =
    Model: Model
    Collection: Collection