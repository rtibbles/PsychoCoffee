'use strict'

Base = require('./Base')
Block = require('./Block')
ExperimentParameterSet = require './ExperimentParameterSet'
File = require './File'

class Model extends Base.Model

    requiredParameters: ->
        super().concat(
            [
                # This attribute determines the time intervals between
                # saves to the API for experimental data.
                # Larger save intervals will give better performance,
                # But increase risk of data loss.
                name: "saveInterval"
                default: 10000
                type: "Number"
            ])

    relations: [
        type: Backbone.Many
        key: 'blocks'
        collectionType: Block.Collection
    ,
        type: Backbone.One
        key: 'parameterSet'
        relatedModel: ExperimentParameterSet.Model
    ,
        type: Backbone.Many
        key: 'files'
        collectionType: File.Collection
    ]


    createBlock: (options) ->
        @.get("blocks").create(options)

    returnParameters: (user_id) ->
        @get("parameterSet").returnExperimentParameters user_id

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
