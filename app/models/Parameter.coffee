'use strict'

NestedBase = require './NestedBase'
Random = require 'utils/random'

class Model extends NestedBase.Model

    ###
    Parameter attributes can be of two basic returnTypes:
    
    fixedList       equivalent to a simple list of parameters.
                    Each attribute defined in this way has an equal
                    length array of values which must be greater than
                    or equal to the requested number of trials.

    generatorFn     Parameters are defined by mathematical functions. Requires
                    input value for functions (either single value or array of
                    same length as number of parameters), function to change
                    input values by (either single function or array of
                    functions), and number of trials wanted.

    Further, Parameter Attributes can have additional methods based on their
    dataType, for example, an Array dataType is allowed to be shuffled.
    ###

    requiredParameters: ->
        super().concat([
            name: "dataType"
            default: "String"
            type: "String"
            options: [
                "String"
                "Array"
                "Number"
                "Colour"
                "Boolean"
                "File"
            ]
        ])

    fixedItems: ->
        super().concat([
            name: "parameters"
            default: []
            type: "Array"
        ,
            name: "returnType"
            default: "fixedList"
            type: "String"
        ])

    returnParameterList: (user_id = "") ->
        switch @get "returnType"
            when "fixedList"
                data = @fixedList(user_id)
            when "generatorFn"
                data = @generatorFn(user_id)
            else console.log "ParameterSet returnType undefined!"
        if @get("dataType") == "Array"
            if @get "shuffled"
                data = @shuffleListArrays(user_id, data)
        return data

    fixedList: (user_id) ->
        return @get "parameters"

    generatorFn: (user_id) ->
        return {}

    shuffleListArrays: (user_id, list) ->
        for item, index in list
            list[index] = Random.seeded_shuffle item,
                user_id + "shuffleListArrays" + @id + index
        return list

class Collection extends NestedBase.Collection
    model: Model

    ###
    Parameter Collections can return parameters in two ways:

    fixedRows       equivalent to a CSV or spreadsheet of parameters.
                    Each parameter will be instantiated alongside the parameter
                    in the same 'row' of the table.
                    This is the default, set by fixed=true.

    crossedRows     each parameter will be crossed with all other parameters to
                    to give an exhaustive list of all possible combinations.
                    Set by fixed=false.
    ###

    generateCombinations: (parameterSet) ->
        # Modified from http://stackoverflow.com/a/15310051
        r = []
        arg = _.pairs(parameterSet)
        max = arg.length-1

        helper = (obj, i) ->
            for j in [0...arg[i][1].length]
                # clone obj
                a = _.clone(obj)
                a[arg[i][0]] = arg[i][1][j]
                if i==max
                    r.push(a)
                else
                    helper(a, i+1)
        helper({}, 0)
        return r

    generateParameters: (user_id, fixed=true) ->
        parameterObjectList = []
        parameterNameList = []

        # Collect trial parameters
        parameterSet = {}
        for model in @models
            parameterList = model.returnParameterList(
                user_id)
            parameterSet[model.get("parameterName")] = parameterList
            min_length = Math.min(min_length, parameterList.length) or
                parameterList.length

        # A parameterSet of at least length 1 needs to be returned in order for
        # for any trials to be run.

        if not min_length? or min_length==0 then min_length = 1

        if fixed
            # If returning fixedRows, we can only return as many parameter sets
            # as the number of items in the parameter with the least items.

            # Do some checking to make sure that the resultant trial lists are
            # of equal length. If not, play it safe and reduce them all to the
            # shortest one to allow the trials to go ahead. Warn of the issue.
            for key, value of parameterSet
                parameterSet[key] = value[0...min_length]
                parameterNameList.push key

            for i in [0...min_length]
                parameters =
                    _.object parameterNameList,
                        (parameterSet[parameter][i] \
                            for parameter in parameterNameList)
                parameterObjectList.push parameters

        else
            parameterObjectList = @generateCombinations(parameterSet)
            min_length = parameterObjectList.length

        [min_length, parameterObjectList]

module.exports =
    Model: Model
    Collection: Collection
