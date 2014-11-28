# Base class for all views.
module.exports = class View extends Backbone.View

    events:
        "dragstart [draggable='true']": "dragStart"
        "dragend [draggable='true']": "dragEnd"
        "dragenter .dropable": "dragEnter"
        "dragleave .dropable": "dragLeave"
        "dragover .dropable": "dragOver"
        "drop .dropable": "drop"

    dragStart: (event) ->
        event.stopPropagation()

    dragEnd: (event) ->
        event.stopPropagation()

    dragEnter: (event) ->
        event.preventDefault()

    dragLeave: (event) ->
        event.preventDefault()

    dragOver: (event) ->
        event.preventDefault()

    drop: (event) =>
        console.log "Dropped in #{@constructor.name}"
        event.stopPropagation()

    template: ->
        return

    getRenderData: ->
        return @model?.attributes or {}

    render: =>
        console.debug "Rendering #{@constructor.name}"
        @$el.html @template @getRenderData()
        @afterRender()
        return @

    appendTo: (el) =>
        $(el).append(@el)

    afterRender: ->
        return