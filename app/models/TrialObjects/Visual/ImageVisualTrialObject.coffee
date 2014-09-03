'use strict'

define ['cs!../VisualTrialObject'],
    (VisualTrialObject) ->

    class Model extends VisualTrialObject.Model

        requiredParameters: ->
            [
                name: "file"
                default: ""
                type: "file"
                extensions: ["png", "jpg", "gif"]
            ]

        name: ->
            @get("name") or @get("file")

    Model: Model
    Type: "image"