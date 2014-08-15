'use strict'

Base = require('./Base')
Block = require('./Block')

class Model extends Base.Model
    defaults:
        blocks: []
        title: "Experiment"
        # This attribute determines the time intervals between
        # saves to the API for experimental data.
        # Larger save intervals will give better performance,
        # But increase risk of data loss.
        saveInterval: 10000

    relations: [
        type: Backbone.Many
        key: 'blocks'
        collectionType: Block.Collection
    ]

    createBlock: (options) ->
        @.get("blocks").create(options)

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
