View = require './View'

module.exports = class DraggableView extends View

    events:
        "dragstart [draggable='true']": "dragStart"
        "dragend [draggable='true']": "dragEnd"

    initialize: ->
        @listenTo @model, "dragstart", @dragStart
        @listenTo @model, "dragend", @dragEnd

    dragStart: (event, data, clone, element) =>
        console.log "Dragging #{@constructor.name}"
        event?.stopPropagation()

    dragEnd: (event) =>
        console.log "No Longer Dragging #{@constructor.name}"
        event?.stopPropagation()