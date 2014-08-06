'use strict'

Base = require('./Base')

class Model extends Base.Model


class Collection extends Base.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection