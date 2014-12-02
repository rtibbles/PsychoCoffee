'use strict'

Base = require './Base'
Trial = require './Trial'
TrialObject = require './TrialObject'
BlockParameterSet = require './BlockParameterSet'

class Model extends Base.Model

    requiredParameters: ->
        super.concat(
            [
                name: "width"
                default: 640
                type: "Number"
            ,
                name: "height"
                default: 480
                type: "Number"
            ,
                name: "timeout"
                default: 0
                type: "Number"
            ])

    trialProperties: [
        "name"
        "width"
        "height"
        "timeout"
        "flow"
    ]

    relations: [
        type: Backbone.Many
        key: 'trials'
        collectionType: Trial.Collection
    ,
        type: Backbone.Many
        key: 'trialObjects'
        collectionType: TrialObject.Collection
    ,
        type: Backbone.One
        key: 'parameterSet'
        relatedModel: BlockParameterSet.Model
    ]

    returnParameters: (user_id, experimentParameters) ->
        @get("parameterSet").returnTrialParameters(
            user_id, @get("numberOfTrials"), experimentParameters)

    returnTrialProperties: (parameters={}) ->
        attributes = {}
        for key in @trialProperties
            attributes[key] = @get(key)
        for attribute, parameterName of @get "parameterizedAttributes"
            if parameterName of parameters
                # This allows parameters to be undefined without breaking
                # the experiment - can be used to dynamically parameterize
                # trials, e.g. by having them parameterized in some
                # conditions but not others
                attributes[attribute] = parameters[parameterName]
        return attributes

    createTrialObject: (options) ->
        @get("trialObjects").create(options)

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
