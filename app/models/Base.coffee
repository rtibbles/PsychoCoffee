'use strict'

class Model extends Backbone.AssociatedModel
    name: ->
        @get("name") or @id

class Collection extends Backbone.Collection
    url: "none"
    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
