'use strict'

define ['cs!./Base', 'cs!./TrialObject'],
    (Base, TrialObject) ->

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

    Model: Model
    Collection: Collection