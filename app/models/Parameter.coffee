'use strict'

Base = require('./Base')
Random = require 'utils/random'

class Model extends Base.Model

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
    ###

    defaults:
        returnType: "fixedList"
        randomized: false
        parameterName: "Untitled Parameter"
        parameters: []
        parameterizedAttributes: {}

    returnParameterList: (trials_wanted=null, injectedParameters={}) ->
        for attribute, name of @get "parameterizedAttributes"
            if name of injectedParameters
                console.log "Injecting!"
                @set attribute, injectedParameters[name]
                console.log @get attribute
        switch @get "returnType"
            when "fixedList" then return @fixedList(trials_wanted)
            when "generatedList" then return @generatedList(trials_wanted)
            when "generatorFn" then return @generatorFn(trials_wanted)
            else console.log "ParameterSet returnType undefined!"

    fixedList: (trials_wanted) ->
        parameterList = @get "parameters"
        if parameterList.length < trials_wanted
            console.warn "Trials wanted exceeds fixedList length"
        if @get "randomized"
            parameterList = Random.seeded_shuffle parameterList,
                "TODO - insert a reference to participant ID here!"
        if trials_wanted?
            parameterList = parameterList[0...trials_wanted]
        return parameterList

    generatedList: (trials_wanted) ->
        parameterList = []
        wholelists = Math.floor trials_wanted/@get("parameters").length
        extra_count = trials_wanted % @get("parameters").length
        for i in [0...wholelists]
            parameterList.push.apply parameterList, @get("parameters")
        if @get "randomized"
            extras = Random.seeded_shuffle @get("parameters"),
                "TODO - insert a reference to participant ID here!"
            extras = extras[0...extra_count]
            parameterList.push.apply parameterList, extras
            parameterList = Random.seeded_shuffle parameterList,
                "TODO - insert a reference to participant ID here!"
        else
            parameterList.push.apply parameterList,
                @get("parameters")[0...extra_count]
        return parameterList

    generatorFn: (trials_wanted) ->
        return {}

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
