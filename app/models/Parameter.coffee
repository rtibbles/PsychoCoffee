'use strict'

NestedBase = require './NestedBase'
Random = require 'utils/random'

class Model extends NestedBase.Model

    ###
    Parameter attributes can be of three basic returnTypes:
    
    fixedList       equivalent to a CSV or spreadsheet of parameters.
                    Each attribute defined in this way has an equal
                    length array of values which must be greater than
                    or equal to the requested number of trials.

    generatedList   each parameter can take on one of a set of discrete
                    values, ParameterSet will either return a repeating
                    set (either randomized or not), or can be combined
                    with other parameters to produce all possible
                    combinations.

    generatorFn     Parameters are defined by mathematical functions. Requires
                    input value for functions (either single value or array of
                    same length as number of parameters), function to change
                    input values by (either single function or array of
                    functions), and number of trials wanted.

    Further, Parameter Attributes can have additional methods based on their
    dataType, for example, an Array dataType is allowed to be shuffled.
    ###

    defaults:
        dataType: ""
        returnType: "fixedList"
        randomized: false
        parameterName: "Untitled Parameter"
        parameters: []
        parameterizedAttributes: {}

    returnParameterList: (user_id = "",\
                            trials_wanted = null,\
                            injectedParameters = {}) ->
        for attribute, name of @get "parameterizedAttributes"
            if name of injectedParameters
                @set attribute, injectedParameters[name]
        switch @get "returnType"
            when "fixedList"
                data = @fixedList(user_id, trials_wanted)
            when "generatedList"
                data = @generatedList(user_id, trials_wanted)
            when "generatorFn"
                data = @generatorFn(user_id, trials_wanted)
            else console.log "ParameterSet returnType undefined!"
        if @get("dataType") == "array"
            if @get "shuffled"
                data = @shuffleListArrays(user_id, data)
        return data

    fixedList: (user_id, trials_wanted) ->
        parameterList = @get "parameters"
        if parameterList.length < trials_wanted
            console.warn "Trials wanted exceeds fixedList length"
        if @get "randomized"
            parameterList = Random.seeded_shuffle parameterList,
                user_id + "fixedList" + @id
        if trials_wanted?
            parameterList = parameterList[0...trials_wanted]
        return parameterList

    generatedList: (user_id, trials_wanted) ->
        parameterList = []
        wholelists = Math.floor trials_wanted/@get("parameters").length
        extra_count = trials_wanted % @get("parameters").length
        for i in [0...wholelists]
            parameterList.push.apply parameterList, @get("parameters")
        if @get "randomized"
            extras = Random.seeded_shuffle @get("parameters"),
                user_id + "generatedListExtras" + @id
            extras = extras[0...extra_count]
            parameterList.push.apply parameterList, extras
            parameterList = Random.seeded_shuffle parameterList,
                user_id + "generatedList" + @id
        else
            parameterList.push.apply parameterList,
                @get("parameters")[0...extra_count]
        return parameterList

    generatorFn: (user_id, trials_wanted) ->
        return {}

    shuffleListArrays: (user_id, list) ->
        for item, index in list
            list[index] = Random.seeded_shuffle item,
                user_id + "shuffleListArrays" + @id + index
        return list

class Collection extends NestedBase.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
