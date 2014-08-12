'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class VisualTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @canvas = endpoints.canvas
        @object.setVisible false
        @canvas.add @object

    activate: ->
        @object.setVisible true
        @addToClockChangeEvents("activated")
        super()

    deactivate: ->
        @object.setVisible false
        @addToClockChangeEvents("deactivated")
        super()
