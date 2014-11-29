View = require './View'

module.exports = class DropableView extends View

    events:
        "dragenter .dropable": "dragEnter"
        "dragleave .dropable": "dragLeave"
        "dragover .dropable": "dragOver"
        "drop .dropable": "drop"

    dragEnter: (event) ->
        event.preventDefault()

    dragLeave: (event) ->
        event.preventDefault()

    dragOver: (event) ->
        event.preventDefault()

    drop: (event) =>
        console.log "Dropped in #{@constructor.name}"
        if "text/id" in event.originalEvent.dataTransfer.types
            event.stopPropagation()
            id = event.originalEvent.dataTransfer.getData("text/id")
            model = @global_dispatcher.eventDataTransfer[id]
        return model