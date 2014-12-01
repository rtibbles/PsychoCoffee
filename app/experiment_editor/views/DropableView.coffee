View = require './View'

module.exports = class DropableView extends View

    render: ->
        super
        @$el.droppable
            drop: @drop

    drop: (event, ui) =>
        if ui
            console.log "Dropped in #{@constructor.name}"
            if $(ui.draggable).data("id")
                event.stopPropagation()
                id = $(ui.draggable).data("id")
                model = @global_dispatcher.eventDataTransfer[id]
                return model