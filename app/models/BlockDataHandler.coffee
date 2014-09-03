'use strict'

define ['cs!./NestedAPIBase', 'cs!./TrialDataLog', 'cs!./EventLog'],
    (NestedAPIBase, TrialDataLog, EventLog) ->

    class Model extends NestedAPIBase.Model

        defaults:
            trialdatalogs: []
            blockeventlogs: []

        relations: [
            type: Backbone.Many
            key: 'trialdatalogs'
            collectionType: TrialDataLog.Collection
        ,
            type: Backbone.Many
            key: 'blockeventlogs'
            collectionType: EventLog.Collection
        ]

        logEvent: (event_type, clock, options={}) =>
            @addEvent(
                _.extend options,
                    experiment_time: clock.getTime()
                    event_type: event_type
                    )

        addEvent: (event) ->
            @get("blockeventlogs").create event

    class Collection extends NestedAPIBase.Collection
        model: Model

    Model: Model
    Collection: Collection