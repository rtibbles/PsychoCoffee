View = require './View'

module.exports = class DraggableListView extends View

    events:
        "dragstart [draggable='true']": "dragStart"
        "dragend [draggable='true']": "dragEnd"

    dragStart: (event, data, clone, element) ->
        model = @collection.get event.currentTarget.id
        model?.trigger("dragstart", event, data, clone, element)
        event.stopPropagation()

    dragEnd: (event, data, clone, element) ->
        model = @collection.get event.currentTarget.id
        model?.trigger("dragend", event, data, clone, element)
        event.stopPropagation()