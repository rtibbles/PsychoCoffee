'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class VisualTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @canvas = endpoints.canvas
        @canvas.add @object
        @deactivate()

    activate: ->
        @object.setVisible true
        @trigger "change", @clock.timerElapsed()

    deactivate: ->
        @object.setVisible false
        @trigger "change", @clock.timerElapsed()
