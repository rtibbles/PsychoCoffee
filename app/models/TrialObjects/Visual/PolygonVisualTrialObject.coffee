'use strict'

define ['cs!../VisualTrialObject'],
    (VisualTrialObject) ->

    class Model extends VisualTrialObject.Model

        requiredParameters: ->
            [
                name: "points"
                default: []
                type: "array"
                embedded_type: fabric.Point
            ]

    Model: Model
    Type: "polygon"