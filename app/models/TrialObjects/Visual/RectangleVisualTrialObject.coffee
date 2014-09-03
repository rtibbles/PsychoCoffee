'use strict'

define ['cs!../VisualTrialObject'],
    (VisualTrialObject) ->

    class Model extends VisualTrialObject.Model

        objectOptions: ->
            super().concat(
                [
                        name: "rx"
                        default: 1
                        type: "number"
                    ,
                        name: "ry"
                        default: 1
                        type: "number"
                ])

    Model: Model
    Type: "rectangle"