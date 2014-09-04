'use strict'

random = require 'utils/random'

class Model extends Backbone.AssociatedModel
    name: ->
        @get("name") or @id

    save: (key, val, options) ->
        @set "id", random.seededguid()

class Collection extends Backbone.Collection
    url: "none"
    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
