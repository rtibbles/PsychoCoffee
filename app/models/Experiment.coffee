'use strict'

Base = require('./Base')
Trial = require('./Trial')

class Model extends Base.Model
    defaults:
        trials: []
        title: "Experiment"

    relations: [
        type: Backbone.Many
        key: 'trials'
        collectionType: Trial.Collection
    ]


# Required for Backbone Relational models extended using Coffeescript syntax
# Model.setup()

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
