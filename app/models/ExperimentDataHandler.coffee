'use strict'

APIBase = require('./APIBase')
BlockDataHandler = require('./BlockDataHandler')

class Model extends APIBase.Model

    initialize: =>
        super
        @listenTo @get("blockdatahandlers"), "change", => @trigger "change"
        @listenTo @get("blockdatahandlers"), "add", => @trigger "change"
        @listenTo @get("blockdatahandlers"), "remove", => @trigger "change"

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