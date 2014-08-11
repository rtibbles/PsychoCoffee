'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class VisualTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @canvas = endpoints.canvas
        @canvas.add @object
        @deactivate()

    activate: ->
        @object.setVisible true
        @logEvent("activated")

    deactivate: ->
        @object.setVisible false
        @logEvent("deactivated")
