'use strict'

define ['cs!./Base', 'cs!./Block', 'cs!utils/fingerprint',
    'cs!utils/random', 'cs!./ExperimentParameterSet'],
    (Base, Block, fingerprint, random, ExperimentParameterSet) ->

    class Model extends Base.Model

        initialize: ->
            super
            random.seedGUID fingerprint()

        defaults:
            blocks: []
            title: "Experiment"
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

    Model: Model
    Collection: Collection
