'use strict'

View = require './View'

module.exports = class TrialObjectView extends View

    initialize: ->
        super
        if not @model.get "file" then @render()
        @active = false
        @name = @model.name()
        @listenTo @model, "change", @render

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
        @datamodel.logEvent(
            event_type
            @clock
            _.extend options,
                object: @model.name()
                details: @logDetails()
                )

    addToClockChangeEvents: (event) ->
        @clock.changeEvents.push event

    logDetails: ->
        @model.get("type") or @model.get("subModelTypeAttribute")

    activate: ->
        if not @active
            @trigger "activated"
            @logEvent("activated")
            @active = true
            @listenTo @model, "change", @render
            if @model.get("duration")
                @clock.delayedTrigger(
                    @model.get("duration"),
                    @, @deactivate)

    deactivate: ->
        if @active
            @trigger "deactivated"
            @logEvent("deactivated")
            @active = false
            @stopListening @model, "change", @render

    registerEvents: (siblingViews) =>
        if @model.get("startWithTrial")
            @clock.delayedTrigger @model.get("delay"), @, @activate