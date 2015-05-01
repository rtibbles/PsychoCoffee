'use strict'

View = require './View'

module.exports = class TrialObjectView extends View

    initialize: ->
        super
        @startRender()
        @active = false
        @name = @model.name()
        @listenTo @model, "change", @startRender

    attach: (endpoints) ->
        return

    waitForFileObject: =>
        if not @files.get(@model.get(@model.fileAttr))
            console.debug "File #{@model.get("file")} not found"
            return
        if @files.get(@model.get(@model.fileAttr))?.loaded
            @setFileObject()
        else
            @listenToOnce @files.get(@model.get(@model.fileAttr)),
                "loaded", @setFileObject

    setFileObject: =>
        @file_object = @files.get(@model.get(@model.fileAttr)).file_object
        @file_path = @files.get(@model.get(@model.fileAttr)).downloadURL()
        @render()

    startRender: =>
        if @model.get(@model.fileAttr)
            @waitForFileObject()
        else
            @render()
        console.debug "Rendering #{@constructor.name}"

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

    proxyObjectEvents: (eventlist) =>
        for eventtype in eventlist
            @object.on(eventtype, => @trigger eventtype)