'use strict'

define ['cs!./NestedAPIBase'],
    (NestedAPIBase) ->

    class Model extends NestedAPIBase.Model


    class Collection extends NestedAPIBase.Collection
        model: Model

    Model: Model
    Collection: Collection