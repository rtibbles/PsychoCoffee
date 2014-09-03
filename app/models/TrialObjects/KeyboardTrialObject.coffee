'use strict'

define ['cs!../TrialObject', 'cs!utils/keys'],
    (TrialObject, Keys) ->

    class Model extends TrialObject.Model

        objectOptions: ->
            super().concat([
                name: "keys"
                default: _.keys(Keys.Keys)
                type: "array"
            ])

    Model: Model
    Type: "keyboard"