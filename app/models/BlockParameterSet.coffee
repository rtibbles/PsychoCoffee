'use strict'

Base = require('./Base')
Random = require 'utils/random'
Parameter = require './Parameter'

class Model extends Base.Model

    defaults:
        randomized: false
        trialParameters: []
        blockParameters: []

    relations: [
        type: Backbone.Many
        key: 'trialParameters'
        collectionType: Parameter.Collection
    ,
        type: Backbone.Many
        key: 'blockParameters'
        collectionType: Parameter.Collection
    ]

    returnTrialParameters: (trials_wanted=null, experimentParameterSet={}) ->
        parameterObjectList = []
        parameterNameList = []
        blockParameterSet = {}
        
        # Collect block parameters to inject into trialParameters at generation
        for model in @get("blockParameters").models
            # Block Parameters are intended to be constant across a block
            blockParameterSet[model.get("parameterName")] =
                model.returnParameterList(1, experimentParameterSet)

        # Collect trial parameters
        parameterSet = {}
        for model in @get("trialParameters").models
            parameterList = model.returnParameterList(
                trials_wanted
                blockParameterSet)
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

        # Now that we have a set length for trials, generate lists of experiment
        # parameters to allow them to be passed in with the trial parameters.
        for key, value of experimentParameterSet
            parameterList = []
            for i in [0...min_length]
                parameterList.push.apply parameterList, value
            parameterSet[key] = parameterList
            parameterNameList.push key

        # Now that we have a set length for trials, generate lists of block
        # parameters to allow them to be passed in with the trial parameters.
        for key, value of blockParameterSet
            parameterList = []
            for i in [0...min_length]
                parameterList.push.apply parameterList, value
            parameterSet[key] = parameterList
            parameterNameList.push key

        for i in [0...min_length]
            parameters =
                _.object parameterNameList,
                    (parameterSet[parameter][i] \
                        for parameter in parameterNameList)
            parameterObjectList.push parameters
        if @get "randomized"
            parameterObjectList = Random.seeded_shuffle parameterSet,
                "TODO - insert a reference to participant ID here!"
        return [min_length, parameterObjectList]

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
