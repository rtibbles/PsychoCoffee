'use strict'

View = require './View'

module.exports = class TrialObjectView extends View

    initialize: ->
        super
        if not @model.get "file" then @render()

    attach: (endpoints) ->
        return

    preLoadTrialObject: (queue) =>
        if @model.get("file")
            @object_id = @model.get("file")
            if not queue.getItem(@object_id)
                queue.loadFile src: @object_id
            queue.on "fileload", @postFileLoad

    postFileLoad: (data) =>
        if data.item.src == @model.get("file")
            @file_object = data.result
            @render()

    render: =>
        console.debug "Rendering #{@constructor.name}"
        @$el.html @file_object

    logEvent: (event_type, options={}) =>
        @datamodel.addEvent(
            _.extend options,
                experiment_time: @clock.getTime()
                event_time: @clock.timerElapsed()
                object: @model.name()
                event_type: event_type
                details: @logDetails()
                )

    addToClockChangeEvents: (event) ->
        @clock.changeEvents.push event

    logDetails: ->
        if PsychoCoffee.DEBUG
            @model.attributes
        else
            @model.get("type") or @model.get("subModelTypeAttribute")

    activate: ->
        return

    deactivate: ->
        return

    modelSet: (attr, value) ->
        @model.set attr, value

    registerEvents: (siblingViews) =>
        @clock.delayedTrigger @model.get("delay"), @, @activate
        @clock.delayedTrigger(
            @model.get("delay") + @model.get("duration"),
            @, @deactivate)
        for trigger in (@model.get("triggers") or [])
            view = _.find(siblingViews, (sibling) ->
                sibling.name == trigger.objectName
                )
            @listenTo view, trigger.eventName, =>
                console.log "Triggering", trigger.eventName
                @[trigger.callback](trigger.arguments or {})