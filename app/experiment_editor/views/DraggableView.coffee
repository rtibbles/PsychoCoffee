View = require './View'

module.exports = class DraggableView extends View

    events:
        "dragstart [draggable='true']": "dragStart"
        "dragend [draggable='true']": "dragEnd"

    initialize: ->
        @listenTo @model, "dragstart", @dragStart
        @listenTo @model, "dragend", @dragEnd

    dragStart: (event) =>
        console.log "Dragging #{@constructor.name}"
        if @model?
            event.originalEvent.dataTransfer.setData("text/id", @model.id)
            @global_dispatcher.eventDataTransfer[@model.id] = @model
        event?.stopPropagation()

    dragEnd: (event) =>
        console.log "No Longer Dragging #{@constructor.name}"
        event?.stopPropagation()