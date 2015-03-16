'use strict'

Base = require './Base'

class Model extends Base.Model

    set: (key, val, options) ->
        super
        if key == "name"
            @id = val
        if _.isObject key
            if "name" of key
                @id = key["name"]

class Collection extends Base.Collection

    model: Model

    getById: (model_id) =>
        @get(model_id) or @find (model) -> model.get("name") == model_id

module.exports =
    Model: Model
    Collection: Collection