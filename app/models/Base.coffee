'use strict'

class Model extends Backbone.AssociatedModel


class Collection extends Backbone.Collection
    url: "none"
    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
