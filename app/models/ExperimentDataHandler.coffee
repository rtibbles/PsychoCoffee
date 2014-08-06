'use strict'

APIBase = require('./APIBase')
TrialDataHandler = require('./TrialDataHandler')

class Model extends APIBase.Model
    defaults:
        trialdatahandlers: []

    relations: [
        type: Backbone.Many
        key: 'trialdatahandlers'
        collectionType: TrialDataHandler.Collection
    ]

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