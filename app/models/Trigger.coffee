'use strict'

Base = require('./Base')
TrialObject = require('./TrialObject')

class Model extends Base.Model
    relations: [
        type: Backbone.One
        key: 'source'
        relatedModel: TrialObject.Model
    ,
        type: Backbone.One
        key: 'target'
        relatedModel: TrialObject.Model
    ]
    # listenEvent: "string"
    # triggerEvent: "string"

class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection