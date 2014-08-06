'use strict'

Base = require('./Base')

class Model extends Base.Model


# Required for Backbone Relational models extended using Coffeescript syntax
# Model.setup()

class Collection extends Base.Collection
    # Overwrite base model non-syncing behaviour
    urlBase: "/api/"
    local: false
    model: Model

module.exports =
    Model: Model
    Collection: Collection
