'use strict'

TextVisualTrialObjectView = require '../TextVisualTrialObjectView'

module.exports =
    class MultiLineTextVisualTrialObjectView extends TextVisualTrialObjectView

        render: ->
            if not @object
                @object = new @object_type @model.returnRequired()[0],
                    @model.returnOptions()
            super