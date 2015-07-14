'use strict'

NestedBase = require './NestedBase'
Random = require 'utils/random'
Parameter = require './Parameter'

class Model extends NestedBase.Model

    defaults:
        randomized: false
        fixedRows: true
        trialParameters: []

    relations: [
        type: Backbone.Many
        key: 'trialParameters'
        collectionType: Parameter.Collection
    ]

    setTrialParameters: (user_id = "",\
                            trials_wanted = null) ->
        [min_length, parameterObjectList] =
        @get("trialParameters").generateParameters(
            user_id, @get("fixedRows"))
        if @get "randomized"
            parameterObjectList = Random.seeded_shuffle parameterObjectList,
                user_id + "parameterObjectList" + @id
        @set
            min_length: min_length
            parameterObjectList: parameterObjectList

class Collection extends NestedBase.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
