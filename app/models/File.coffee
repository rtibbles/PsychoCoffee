'use strict'

NestedBase = require './NestedBase'

class Model extends NestedBase.Model

    idAttribute: "file_id"

    preLoadFile: (queue) =>
        if not queue
            queue = new createjs.LoadQueue true
        if not queue.getItem(@get("file_id"))
            queue.loadFile src: @downloadURL()
        queue.on "fileload", @postFileLoad

    postFileLoad: (data) =>
        if data.item.src.search(@get("file_id")) > -1
            @file_object = data.result
            @loaded = true
            @trigger "loaded"

    downloadURL: ->
        "/media/" + @get("file_id")

    deleteURL: ->
        "/files/" + @get("file_id")

class Collection extends Backbone.Collection

    preLoadFiles: (queue) =>
        @models.forEach (model) -> model.preLoadFile(queue)

    url: ""

    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
