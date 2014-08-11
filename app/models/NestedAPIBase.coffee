'use strict'

Base = require('./Base')

class Model extends Base.Model

    save: =>
        super
        for model in @collection.parents
            model.save()

class Collection extends Base.Collection

    model: Model

module.exports =
    Model: Model
    Collection: Collection
