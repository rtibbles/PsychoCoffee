'use strict'

Base = require('./Base')
Block = require('./Block')

class Model extends Base.Model
    defaults:
        blocks: []
        title: "Experiment"

    relations: [
        type: Backbone.Many
        key: 'blocks'
        collectionType: Block.Collection
    ]

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
