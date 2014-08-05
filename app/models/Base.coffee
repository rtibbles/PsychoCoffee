'use strict'

class Model extends Backbone.RelationalModel


# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Backbone.Collection
    url: "none"
    local: true

module.exports =
    Model: Model
    Collection: Collection
