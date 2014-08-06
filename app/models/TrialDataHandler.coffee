'use strict'

Base = require('./Base')
TrialEventLog = require('./TrialEventLog')

class Model extends Base.Model
    defaults:
        trialeventlogs: []

    relations: [
        type: Backbone.Many
        key: 'trialeventlogs'
        relatedModel: TrialEventLog.Model
    ]

# Required for Backbone Relational models extended using Coffeescript syntax
# Model.setup()

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection