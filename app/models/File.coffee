'use strict'

random = require 'utils/random'

class Model extends Backbone.Model
    

class Collection extends Backbone.Collection
    url: ""
    containerURL: ->
        "/api/containers/" + @experiment_id
    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
