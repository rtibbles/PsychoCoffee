'use strict'

Base = require('./Base')
TrialDataHandler = require('./TrialDataHandler')

class Model extends Base.Model
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

class Collection extends Base.Collection
    model: Model
    url: =>
        @urlBase + "experimentdatahandler"

    getOrCreateParticipantModel: (participant_id) ->
        console.log participant_id
        model = @findWhere participant_id: participant_id
        console.log model
        model or @create participant_id: participant_id

module.exports =
    Model: Model
    Collection: Collection