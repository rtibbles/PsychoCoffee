'use strict'

APIBase = require('./APIBase')
TrialDataHandler = require('./TrialDataHandler')

class Model extends APIBase.Model
    relations: [
        type: 'HasMany'
        key: 'trialdatahandlers'
        relatedModel: TrialDataHandler.Model
        includeInJSON: true
        reverseRelation:
            key: "experimentdatahandler"
    ]

# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends APIBase.Collection
    model: Model
    url: =>
        @urlBase + "experimentdatahandlers"

    getOrCreateParticipantModel: (participant_id) ->
        model = @findWhere participant_id: participant_id
        model or @create participant_id: participant_id

module.exports =
    Model: Model
    Collection: Collection