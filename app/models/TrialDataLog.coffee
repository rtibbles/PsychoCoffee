'use strict'

Base = require('./Base')
TrialEventLog = require('./TrialEventLog')

class Model extends Base.Model

    initialize: =>
        super
        @listenTo @get("trialeventlogs"), "change", => @trigger "change"
        @listenTo @get("trialeventlogs"), "add", => @trigger "change"
        @listenTo @get("trialeventlogs"), "remove", => @trigger "change"

    defaults:
        trialeventlogs: []

    relations: [
        type: Backbone.Many
        key: 'trialeventlogs'
        collectionType: TrialEventLog.Collection
    ]

    addEvent: (event) ->
        @get("trialeventlogs").create event

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection