'use strict'

NestedAPIBase = require('./NestedAPIBase')

class Model extends NestedAPIBase.Model


class Collection extends NestedAPIBase.Collection
    model: Model

module.exports =
    Model: Model
    Collection: Collection