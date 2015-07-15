'use strict'

Base = require './Base'
Random = require 'utils/random'
Parameter = require './Parameter'

class Model extends Base.Model

    defaults:
        experimentParameters: []
        fixedRows: true

    relations: [
        type: Backbone.Many
        key: 'experimentParameters'
        collectionType: Parameter.Collection
    ]

    returnExperimentParameters: (user_id="") ->
        [min_length, parameterObjectList] =
        @get("experimentParameters").generateParameters(
            user_id, @get("fixedRows"))
        # Experiment Parameters are intended to be
        # constant across an experiment.
        # Experiment Parameters are always randomized.
        parameters = Random.seeded_shuffle(parameterObjectList,
                user_id + "experimentParameterSet" + @id)[0]

        return parameters

    description: "These variables will be randomized across participants - \
        each participant will only see one set of these possible values"

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
