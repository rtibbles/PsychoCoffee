'use strict'

define ['cs!./Base', 'cs!utils/random', 'cs!./Parameter'],
    (Base, Random, Parameter) ->

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

        returnTrialParameters: (user_id= "",\
                                trials_wanted=null,\
                                experimentParameterSet={}) ->
            parameterObjectList = []
            parameterNameList = []
            blockParameterSet = {}
            
            # Collect block parameters to inject into
            # trialParameters at generation
            for model in @get("blockParameters").models
                # Block Parameters are intended to be constant across a block
                # Block Parameters are always randomized.
                blockParameterSet[model.get("parameterName")] =
                    Random.seeded_shuffle(
                        model.returnParameterList(user_id
                            null
                            experimentParameterSet)
                        user_id + "blockParameterSet" + @id)[0]

            # Collect trial parameters
            parameterSet = {}
            for model in @get("trialParameters").models
                parameterList = model.returnParameterList(
                    user_id
                    trials_wanted
                    blockParameterSet)
                parameterSet[model.get("parameterName")] = parameterList
                min_length = Math.min(min_length, parameterList.length) or
                    parameterList.length

            # Do some checking to make sure that the resultant
            # trial lists are of equal length. If not, play it
            # safe and reduce them all to the shortest one to
            # allow the trials to go ahead. Warn of the issue.
            for key, value of parameterSet
                if value.length < trials_wanted
                    console.warn    """
                                    Parameter #{key} could
                                    not produce sufficient
                                    trials for desired
                                    trials_wanted value.
                                    """
                parameterSet[key] = value[0...min_length]
                parameterNameList.push key


            # A parameterSet of at least length 1 needs to
            # be returned in order for for any trials to be run.

            if not min_length? or min_length==0 then min_length = 1

            # Now that we have a set length for trials, generate lists
            # of experiment parameters to allow them to be passed in
            # with the trial parameters.
            for key, value of experimentParameterSet
                parameterList = []
                for i in [0...min_length]
                    parameterList.push value
                parameterSet[key] = parameterList
                parameterNameList.push key

            # Now that we have a set length for trials, generate
            # lists of block parameters to allow them to be passed
            # in with the trial parameters.
            for key, value of blockParameterSet
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
            return [blockParameterSet, min_length, parameterObjectList]

    class Collection extends Base.Collection
        model: Model

    Model: Model
    Collection: Collection
