'use strict'

random = require 'utils/random'

class Model extends Backbone.AssociatedModel

    save: =>
        @set "id", random.guid()
        for model in @collection.parents
            model.save()

class Collection extends Backbone.Collection

    model: Model

module.exports =
    Model: Model
    Collection: Collection
