'use strict'

Base = require('./Base')

class Model extends Base.Model


# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Base.Collection

module.exports =
    Model: Model
    Collection: Collection