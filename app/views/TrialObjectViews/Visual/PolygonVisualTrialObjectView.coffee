'use strict'

VisualTrialObjectView = require '../VisualTrialObjectView'

module.exports =
    class PolygonVisualTrialObjectView extends VisualTrialObjectView

        object_type:
            fabric.Polygon

        render: ->
            if not @object
                @object = new @object_type @model.get("points"),
                    @model.returnOptions()
            super