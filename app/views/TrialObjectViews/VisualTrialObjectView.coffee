'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class VisualTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @canvas = endpoints.canvas

    activate: ->
        @canvas.add @object

    deactivate: ->
        @canvas.remove @object
