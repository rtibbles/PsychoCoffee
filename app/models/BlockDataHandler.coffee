'use strict'

NestedAPIBase = require('./NestedAPIBase')
TrialDataLog = require('./TrialDataLog')

class Model extends NestedAPIBase.Model

    defaults:
        trialdatalogs: []

    relations: [
        type: Backbone.Many
        key: 'trialdatalogs'
        collectionType: TrialDataLog.Collection
    ]

class Collection extends NestedAPIBase.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection