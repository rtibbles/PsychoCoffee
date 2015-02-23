'use strict'

NestedBase = require './NestedBase'
Random = require 'utils/random'
Parameter = require './Parameter'

class Model extends NestedBase.Model

    defaults:
        randomized: false
        trialParameters: []

    relations: [
        type: Backbone.Many
        key: 'trialParameters'
        collectionType: Parameter.Collection
    ]

    setTrialParameters: (user_id = "",\
                            trials_wanted = null,\
                            experimentParameterSet = {}) ->
        parameterObjectList = []
        parameterNameList = []
        
        # Collect trial parameters
        parameterSet = {}
        for model in @get("trialParameters").models
            parameterList = model.returnParameterList(
                user_id
                trials_wanted
                experimentParameterSet)
            parameterSet[model.get("parameterName")] = parameterList
            min_length = Math.min(min_length, parameterList.length) or
                parameterList.length

        # Do some checking to make sure that the resultant trial lists are of
        # equal length. If not, play it safe and reduce them all to the
        # shortest one to allow the trials to go ahead. Warn of the issue.
        for key, value of parameterSet
            if value.length < trials_wanted
                console.warn    """
                                Parameter #{key} could not produce sufficient
                                trials for desired trials_wanted value.
                                """
            parameterSet[key] = value[0...min_length]
            parameterNameList.push key


        # A parameterSet of at least length 1 needs to be returned in order for
        # for any trials to be run.

        if not min_length? or min_length==0 then min_length = 1

        # Now that we have a set length for trials, generate lists of experiment
        # parameters to allow them to be passed in with the trial parameters.
        for key, value of experimentParameterSet
            parameterList = []
            for i in [0...min_length]
                parameterList.push value
            parameterSet[key] = parameterList
            parameterNameList.push key

        for i in [0...min_length]
            parameters =
                _.object parameterNameList,
                    (parameterSet[parameter][i] \
                        for parameter in parameterNameList)
            parameterObjectList.push parameters
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
