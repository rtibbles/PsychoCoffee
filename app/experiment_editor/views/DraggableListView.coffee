View = require './View'

module.exports = class DraggableListView extends View

    events:
        "dragstart [draggable='true']": "dragStart"
        "dragend [draggable='true']": "dragEnd"

    dragStart: (event) ->
        model = @collection.get event.currentTarget.id
        model?.trigger("dragstart", event)
        event.stopPropagation()

    dragEnd: (event) ->
        model = @collection.get event.currentTarget.id
        model?.trigger("dragend", event)
        event.stopPropagation()