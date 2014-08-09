'use strict'

Base = require('./Base')
Random = require 'utils/random'

class Model extends Base.Model

    ###
    Parameters can be of three basic types:
    fixedList   equivalent to a CSV or spreadsheet of parameters.
                Each attribute has an equal length array of values
                which will be assigned based on the index.
    randomList  each parameter can take on one of a set of discrete
                values, ParameterSet will return all possible combinations,
                or a pseudorandom subset up to a max number. Subset will be
                seeded by participant id so will be deterministic on refresh.
    generatorFn Parameters are defined by mathematical functions. Requires
                input value for functions (either single value or array of
                same length as number of parameters), function to change input
                values by (either single function or array of functions), and
                number of trials wanted.
    ###

    defaults:
        type: "fixedList"
        randomized: false

    returnTrialParameters: (trials_wanted=null) ->
        switch @get "type"
            when "fixedList" then return @fixedList(trials_wanted)
            when "randomList" then return @randomList(trials_wanted)
            when "generatorFn" then return @generatorFn(trials_wanted)
            else console.log "ParameterSet type undefined!"

    fixedList: (trials_wanted) ->
        length = 0
        parameterSet = []
        parameterList = []
        for key, value of @get "parameters"
            parameterList.push key
            length = value.length
        for i in [0...length]
            parameters =
                _.object parameterList,
                    (@get("parameters")[parameter][i] \
                        for parameter in parameterList)
            parameterSet.push parameters
        parameterSet = Random.seeded_shuffle parameterSet,
            "TODO - insert a reference to participant ID here!"
        if trials_wanted?
            parameterSet = parameterSet[0...trials_wanted]
        return [length, parameterSet]

    randomList: (trials_wanted) ->
        return {}

    generatorFn: (trials_wanted) ->
        return {}

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
