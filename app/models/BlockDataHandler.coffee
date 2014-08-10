'use strict'

Base = require('./Base')
TrialDataLog = require('./TrialDataLog')

class Model extends Base.Model

    initialize: =>
        super
        @listenTo @get("trialdatalogs"), "change", => @trigger "change"
        @listenTo @get("trialdatalogs"), "add", => @trigger "change"
        @listenTo @get("trialdatalogs"), "remove", => @trigger "change"

    defaults:
        trialdatalogs: []

    relations: [
        type: Backbone.Many
        key: 'trialdatalogs'
        collectionType: TrialDataLog.Collection
    ]

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection