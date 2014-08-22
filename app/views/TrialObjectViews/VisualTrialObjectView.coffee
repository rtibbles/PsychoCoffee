'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class VisualTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @canvas = endpoints.canvas
        @object.setVisible false
        @canvas.add @object

    activate: ->
        @object.hasControls = false
        @object.hasBorders = false
        @object.lockMovementX = @object.lockMovementY = true
        @object.setVisible true
        @addToClockChangeEvents("activated")
        @object.on "mousedown", (event) =>
            @trigger "click"
            @logEvent "click"
        super()

    deactivate: ->
        @object.setVisible false
        @addToClockChangeEvents("deactivated")
        @object.off "mousedown"
        super()

    render: ->
        if not @object
            @object = new @object_type()
        @object.set @model.allParameters()
        @addToClockChangeEvents("change")