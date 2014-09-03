'use strict'

define ['cs!./NestedAPIBase', 'cs!./EventLog'],
    (NestedAPIBase, EventLog) ->

    class Model extends NestedAPIBase.Model

        defaults:
            trialeventlogs: []

        relations: [
            type: Backbone.Many
            key: 'trialeventlogs'
            collectionType: EventLog.Collection
        ]

        logEvent: (event_type, clock, options={}) =>
            @addEvent(
                _.extend options,
                    experiment_time: clock.getTime()
                    trial_time: clock.timerElapsed()
                    event_type: event_type
                    )

        addEvent: (event) ->
            @get("trialeventlogs").create event

    class Collection extends NestedAPIBase.Collection
        model: Model

    Model: Model
    Collection: Collection