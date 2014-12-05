'use strict'

class Model extends Backbone.Model

    preLoadFile: (queue) =>
        if not queue.getItem(@get("name"))
            queue.loadFile src: @downloadURL()
        queue.on "fileload", @postFileLoad

    postFileLoad: (data) =>
        if data.item.src == @get("name")
            @file_object = data.result
            @loaded = true
            @trigger "loaded"

    downloadURL: ->
        @containerURL + "/download/" + @get("name")

    deleteURL: ->
        @containerURL + "/files/" + @get("name")

    containerURL: ->
        "/api/containers/" + "test"#@collection.parents[0].id

class Collection extends Backbone.Collection

    preLoadFiles: (queue) =>
        @models.forEach (model) -> model.preLoadFile(queue)

    url: ""
    containerURL: ->
        "/api/containers/" + "test"#@parents[0].id
    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
