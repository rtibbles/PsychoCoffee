'use strict'

Base = require('./Base')
TrialObject = require('./TrialObject')

class Model extends Base.Model
    relations: [
        type: 'hasOne'
        key: 'source'
        relatedModel: "TrialObject.Model"
    ,
        type: 'hasOne'
        key: 'target'
        relatedModel: "TrialObject.Model"
    ]
    # listenEvent: "string"
    # triggerEvent: "string"


# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Base.Collection

module.exports =
    Model: Model
    Collection: Collection