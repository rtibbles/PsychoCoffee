'use strict'

HandlerView = require './HandlerView'
Template = require 'templates/trial'

module.exports = class TrialView extends HandlerView
    template: Template

    initialize: (options) =>
        super
        @instantiateSubViews("trialObjects",
            "TrialObjectView", @trialObjectViewType)
        @registerSubViewSubViews()

    preLoadTrial: (queue) =>
        for key, view of @subViews
            view.preLoadTrialObject(queue)

    trialObjectViewType: (model) ->
        elementType = model.get("subModelTypeAttribute") or
            PsychoCoffee.trialObjectTypeKeys[model.get("type")]

        # For this to work, any models subclassed from TrialObject must be named
        # ModelName, and the associated View must be named ModelNameView

        elementView = elementType + "View"

        try
            PsychoCoffee[elementView]
            elementView
        catch error
            console.debug error, "Unknown element type #{elementType}"

    startTrial: ->
        date_time = new Date().getTime()
        if @datamodel.get("start_time")?
            @logEvent "trial_resume", date_time: date_time
        else
            @datamodel.set "start_time", date_time
            @logEvent "trial_start", date_time: date_time
        @datamodel.set "trial_id", @model.id
        @createCanvas()
        endpoints =
            canvas: @canvas
            hidden: @$("#trial-hidden")
            elements: @$("#trial-elements")
        for view in @subViewList
            view.attach endpoints
            view.datamodel = @datamodel
            view.registerEvents(@subViewList)
        @registerEvents()
        @registerTimeout()
        @clock.startTimer()

    createCanvas: =>
        @canvas = new fabric.Canvas "trial-canvas"
        @canvas.selection = false
        @canvas.hoverCursor = 'default'
        @clock.canvas = @canvas
        if not Modernizr.pointerevents
            for eventType in [
                "mousedown"
                "mouseup"
             ]
                @$("#trial-elements")[eventType]((event) =>
                    target = @canvas.findTarget event
                    target.trigger(eventType)
                    )

    canvasPerformanceTracking: (options) =>
        now = options.event_time
        @canvas.on "after:render", =>
            console.log @clock.timerElapsed() - now,
                "ms between object added/removed and render completion"
            @canvas.off("after:render")

    registerTimeout: =>
        if @model.get "timeout"
            @clock.delayedTrigger @model.get("timeout"), @, @endTrial

    endTrial: ->
        date_time = new Date().getTime()
        @logEvent "trial_end", date_time: date_time
        @datamodel.set "end_time", date_time
        for key, view of @subViews
            view.deactivate()
            view.remove()
        @clock.stopTimer()
        delete @clock.canvas
        delete @canvas
        @stopListening()
        @remove()
        @trigger "trialEnded"

    registerEvents: =>
        for trigger in (@model.get("triggers") or [])
            view = _.find(@subViews, (subView) ->
                subView.name == trigger.objectName
                )
            @listenTo view, trigger.eventName, =>
                @[trigger.callback](trigger.arguments or {})