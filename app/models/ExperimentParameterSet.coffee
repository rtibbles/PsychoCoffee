'use strict'

define ['cs!./Base', 'cs!utils/random', 'cs!./Parameter'],
    (Base, Random, Parameter) ->

    class Model extends Base.Model

        defaults:
            randomized: false
            experimentParameters: []

        relations: [
            type: Backbone.Many
            key: 'experimentParameters'
            collectionType: Parameter.Collection
        ]

        returnExperimentParameters: (user_id="") ->
            experimentParameterSet = {}
            
            # Collect experiment parameters to inject
            # into blockParameters at generation
            for model in @get("experimentParameters").models
                # Experiment Parameters are intended to be
                # constant across an experiment.
                # Experiment Parameters are always randomized.
                experimentParameterSet[model.get("parameterName")] =
                    Random.seeded_shuffle(
                        model.returnParameterList(user_id
                            null
                            experimentParameterSet)
                        user_id + "experimentParameterSet" + @id)[0]

            return experimentParameterSet

    class Collection extends Base.Collection
        model: Model

    Model: Model
    Collection: Collection
