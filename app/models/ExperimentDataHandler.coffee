'use strict'

APIBase = require('./APIBase')
BlockDataHandler = require('./BlockDataHandler')

class Model extends APIBase.Model
    defaults:
        blockdatahandlers: []

    relations: [
        type: Backbone.Many
        key: 'blockdatahandlers'
        collectionType: BlockDataHandler.Collection
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