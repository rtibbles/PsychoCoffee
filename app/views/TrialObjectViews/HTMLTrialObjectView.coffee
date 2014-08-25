'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class HTMLTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @$el.hide()
        @appendTo endpoints.elements

    activate: ->
        @$el.show()
        super()

    deactivate: ->
        @$el.hide()
        super()

    render: ->
        @$el.html @template @model.allParameters()