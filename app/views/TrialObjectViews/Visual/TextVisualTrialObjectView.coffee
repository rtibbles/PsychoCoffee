'use strict'

VisualTrialObjectView = require '../VisualTrialObjectView'

module.exports = class TextVisualTrialObjectView extends VisualTrialObjectView

    render: ->
        @object = new fabric.Text @model.get "text"