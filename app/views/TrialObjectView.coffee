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

    logEvent: (event_type) =>
        @trigger "change",
            event_time: @clock.timerElapsed()
            object: @model.name()
            event_type: event_type
            details: @logDetails()

    logDetails: ->
        if PsychoCoffee.DEBUG
            @model.attributes
        else
            @model.get("type") or @model.get("subModelTypeAttribute")

    activate: ->
        return

    deactivate: ->
        return

    registerEvents: =>
        @clock.delayedTrigger @model.get("delay"), @, @activate
        @clock.delayedTrigger(
            @model.get("delay") + @model.get("duration"),
            @, @deactivate)