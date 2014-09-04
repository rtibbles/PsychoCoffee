'use strict'

Base = require('./Base')
TrialObject = require("./TrialObject")

class Model extends Base.Model
    defaults:
        width: 640
        height: 480
        trialObjects: []

    relations: [
        type: Backbone.Many
        key: 'trialObjects'
        collectionType: TrialObject.Collection
    ]

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection