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
            @object_id = @model.id
            queue.loadFile id: @object_id, src: @model.get("file")
            queue.on "fileload", @postFileLoad

    postFileLoad: (data) =>
        if data.item.src == @model.get("file")
            @file_object = data.result
            @render()

    render: =>
        console.debug "Rendering #{@constructor.name}"
        @$el.html @file_object

    activate: ->
        return

    deactivate: ->
        return

    registerEvents: =>
        @clock.delayedTrigger @model.get("delay"), @, @activate
        @clock.delayedTrigger(
            @model.get("delay") + @model.get("duration"),
            @, @deactivate)