'use strict'

Base = require './Base'
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

    relations: [
        type: Backbone.Many
        key: 'trialObjects'
        collectionType: TrialObject.Collection
    ,
        type: Backbone.One
        key: 'parameterSet'
        relatedModel: BlockParameterSet.Model
    ]

    setParameters: (user_id, experimentParameters) ->
        @get("parameterSet").setTrialParameters(
            user_id, @get("numberOfTrials"), experimentParameters)

    setTrialParameters: (trial) ->
        @set "trialParameters",
            @get("parameterSet").get("parameterObjectList")[trial]

    createTrialObject: (options) ->
        @get("trialObjects").create(options)

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
