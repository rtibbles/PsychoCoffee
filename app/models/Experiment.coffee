'use strict'

Base = require('./Base')
Block = require('./Block')
fingerprint = require 'utils/fingerprint'
random = require 'utils/random'
ExperimentParameterSet = require './ExperimentParameterSet'

class Model extends Base.Model

    initialize: ->
        super
        random.seedGUID fingerprint()

    defaults:
        blocks: []
        name: "Experiment"
        # This attribute determines the time intervals between
        # saves to the API for experimental data.
        # Larger save intervals will give better performance,
        # But increase risk of data loss.
        saveInterval: 10000
        parameterSet: {}

    relations: [
        type: Backbone.Many
        key: 'blocks'
        collectionType: Block.Collection
    ,
        type: Backbone.One
        key: 'parameterSet'
        relatedModel: ExperimentParameterSet.Model
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
