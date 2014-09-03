'use strict'

define ['cs!utils/random'], (random) ->

    class Model extends Backbone.AssociatedModel
        name: ->
            @get("name") or @id

        save: (key, val, options) ->
            @set "id", random.seededguid()

    class Collection extends Backbone.Collection
        url: "none"
        local: true
        model: Model

   
    Model: Model
    Collection: Collection
