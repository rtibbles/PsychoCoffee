'use strict'

hashObject = require 'utils/hashObject'

class Model extends Backbone.AssociatedModel

    save: =>
        @set "id", hashObject @collection.parents[0].toJSON()
        for model in @collection.parents
            model.save()

class Collection extends Backbone.Collection

    model: Model

module.exports =
    Model: Model
    Collection: Collection
