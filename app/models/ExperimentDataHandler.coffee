'use strict'

APIBase = require './APIBase'
BlockDataHandler = require './BlockDataHandler'

class Model extends APIBase.Model

    initialize: ->
        @lastSync = 0

    defaults:
        blockdatahandlers: []

    relations: [
        type: Backbone.Many
        key: 'blockdatahandlers'
        collectionType: BlockDataHandler.Collection
    ]

    sync: (method, model, options) =>
        syncNow = => @syncNow(method,model,options)
        delayTime = @lastSync + @get("saveInterval") - performance.now()
        if delayTime <= 0
            @syncNow()
        else
            if not @syncCache
                @syncCache = setTimeout syncNow, delayTime

    syncNow: (method, model, options) =>
        @lastSync = performance.now()
        clearTimeout(@syncCache)
        delete @syncCache
        Backbone.sync(method, model, options)
        

class Collection extends APIBase.Collection
    model: Model
    url: =>
        @urlBase + "experimentdatahandlers"

    getOrCreateParticipantModel: (participant_id, saveInterval) ->
        model = @findWhere participant_id: participant_id
        model or @create
            participant_id: participant_id
            saveInterval: saveInterval

module.exports =
    Model: Model
    Collection: Collection