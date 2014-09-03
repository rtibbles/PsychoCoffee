'use strict'

define ['cs!../TrialObject'],
    (TrialObject) ->

    class Model extends TrialObject.Model

        name: ->
            @get("name") or @get("file")

    Model: Model
    Type: "audio"