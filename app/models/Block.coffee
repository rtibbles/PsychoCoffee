'use strict'

Base = require './Base'
Trial = require './Trial'
TrialObject = require './TrialObject'
ParameterSet = require './ParameterSet'

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
        relatedModel: ParameterSet.Model
    ]

    returnParameters: ->
        @get("parameterSet").returnTrialParameters @get("numberOfTrials")

    returnTrialProperties: ->
        attributes = {}
        for key in @trialProperties
            attributes[key] = @get(key)
        return attributes

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection
