'use strict'

define ['cs!../VisualTrialObject'],
    (VisualTrialObject) ->

    class Model extends VisualTrialObject.Model

        objectOptions: ->
            super().concat(
                [
                        name: "ry"
                        default: 24
                        type: "number"
                    ,
                        name: "ry"
                        default: 24
                        type: "number"
                ])

    Model: Model
    Type: "ellipse"