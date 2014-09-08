'use strict'

TextVisualTrialObjectView = require '../TextVisualTrialObjectView'
wrapCanvasText = require 'utils/wrapCanvasText'

module.exports =
    class MultiLineTextVisualTrialObjectView extends TextVisualTrialObjectView

        render: ->
            super
            if @canvas
                @object = wrapCanvasText(
                    @object
                    @canvas
                    @model.get("width")
                    @model.get("height")
                    @model.get("justify")
                    )