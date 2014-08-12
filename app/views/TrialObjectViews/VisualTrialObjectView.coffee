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
        @logEvent("activated")

    deactivate: ->
        @object.setVisible false
        @addToClockChangeEvents("deactivated")
        @logEvent("deactivated")
