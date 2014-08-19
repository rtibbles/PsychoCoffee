'use strict'

Base = require './Base'
Trial = require './Trial'
TrialObject = require './TrialObject'
BlockParameterSet = require './BlockParameterSet'

class Model extends Base.Model
    defaults:
        trials: []
        title: ""
        width: 640
        height: 480
        timeout: 1000
        parameterSet: {}
        trialObjects: []

    trialProperties: [
        "title"
        "width"
        "height"
        "timeout"
        "triggers"
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

    returnParameters: ->
        @get("parameterSet").returnTrialParameters @get("numberOfTrials")

    returnTrialProperties: (clone=false) ->
        attributes = {}
        for key in @trialProperties
            attributes[key] = @get(key)
        if clone then attributes["trialObjects"] = @get "trialObjects"
        return attributes

    createTrialObject: (options) ->
        @get("trialObjects").create(options)

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
