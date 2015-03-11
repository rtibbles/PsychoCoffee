View = require './View'

module.exports = class DraggableView extends View

    initialize: ->
        @listenTo @model, "dragstart", @dragStart
        @listenTo @model, "dragend", @dragEnd

    render: =>
        super
        @$el.draggable(
            start: @dragStart
            end: @dragEnd
            helper: "clone"
            iframeFix: true
            zIndex: 1000
            ).data("id", @model.id or @model.get("name"))

    dragStart: (event, ui) =>
        console.log "Dragging #{@constructor.name}"
        if @model?
            id = @model.id or @model.get("name")
            @global_dispatcher.eventDataTransfer[id] = @model
        event?.stopPropagation()

    dragEnd: (event, ui) =>
        ui.helper.remove()
        console.log "No Longer Dragging #{@constructor.name}"
        event?.stopPropagation()