'use strict'

class Model extends Backbone.RelationalModel


# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Backbone.Collection
    urlBase: "/api/"

module.exports =
    Model: Model
    Collection: Collection
