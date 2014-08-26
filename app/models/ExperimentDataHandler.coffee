'use strict'

APIBase = require './APIBase'
BlockDataHandler = require './BlockDataHandler'
Diff = require 'utils/diff'

class Model extends APIBase.Model

    initialize: ->
        @lastSync = 0
        @serverState = @toJSON()

    defaults:
        blockdatahandlers: []

    relations: [
        type: Backbone.Many
        key: 'blockdatahandlers'
        collectionType: BlockDataHandler.Collection
    ]

    sync: (method, model, options={}) =>
        if model?
            syncNow = => @syncNow(method,model,options)
            delayTime = @lastSync + @get("saveInterval") - performance.now()
            if delayTime <= 0
                @syncNow()
            else
                if not @syncCache
                    @syncCache = setTimeout syncNow, delayTime

    syncNow: (method, model, options={}) =>
        if model?
            if not @isNew()
                options.attrs = Diff.Diff(@serverState, model.toJSON())
                options.method = 'patch'
                options.success = (saved) =>
                    if saved.patched
                        @set model.attributes
                        @serverState = model.toJSON()
            else
                options.success = (data) =>
                    @set(data)
                    @serverState = @toJSON()
            @lastSync = performance.now()
            clearTimeout(@syncCache)
            delete @syncCache
            try
                Backbone.sync(method, model, options)
            catch e
                console.debug e, method, model, options
        

class Collection extends APIBase.Collection

    model: Model
    storeName: "experimentData"
    apiCollection: "experimentdatahandlers"
    apiFilters: ["experiment_identifier", "participant_id"]


    getOrCreateParticipantModel: (participant_id, experiment_model) ->
        model = @findWhere
            participant_id: participant_id
            experiment_identifier: experiment_model.get("identifier")
        model or @create
            participant_id: participant_id
            saveInterval: experiment_model.get("saveInterval")
            experiment_identifier: experiment_model.get("identifier")

module.exports =
    Model: Model
    Collection: Collection