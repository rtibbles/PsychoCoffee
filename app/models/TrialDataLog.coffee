'use strict'

NestedAPIBase = require('./NestedAPIBase')
TrialEventLog = require('./TrialEventLog')

class Model extends NestedAPIBase.Model

    defaults:
        trialeventlogs: []

    relations: [
        type: Backbone.Many
        key: 'trialeventlogs'
        collectionType: TrialEventLog.Collection
    ]

    addEvent: (event) ->
        @get("trialeventlogs").create event

class Collection extends NestedAPIBase.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection