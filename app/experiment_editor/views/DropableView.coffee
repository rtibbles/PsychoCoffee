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
        event.stopPropagation()