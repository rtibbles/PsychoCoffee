'use strict'

class Model extends Backbone.Model
    local: true

class Collection extends Backbone.Collection
    local: true

module.exports =
    Model: Model
    Collection: Collection