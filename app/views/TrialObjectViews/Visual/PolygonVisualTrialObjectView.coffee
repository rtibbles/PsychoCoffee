'use strict'

VisualTrialObjectView = require '../VisualTrialObjectView'

module.exports =
    class PolygonVisualTrialObjectView extends VisualTrialObjectView

        object_type:
            fabric.Polygon

        render: ->
            @object = new @object_type @model.returnRequired()[0],
                @model.returnOptions()