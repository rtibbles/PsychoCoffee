'use strict'

nestedModules = require '../utils/nestedModules'

Base = require('./Base')

subModels = {}
for modulename in nestedModules('models/TrialObjects')
    subModels[modulename] = modulename + ".Model"

class Model extends Base.Model
    subModelTypes: subModels

    fileKey: "fileData"
    object: Object
    objectFileKey: "data"

    defaults: ->
        delay: 0
        duration: 5

    preloadFile: =>
        $.ajax
            method: "GET"
            url: @get("file")
            cache: true
            # processData : false
            success: @postFileLoad
            progress: @reportProgress

    reportProgress: (event) =>
        if event.lengthComputable
            fraction = event.loaded/event.total
        @trigger "fileProgress",
            fraction: fraction
            model: @

    postFileLoad: (data) =>
        object = new @object()
        key = @objectFileKey
        object[key] = @get "file"
        @set @fileKey, object
        @trigger "fileProgress",
            model: @
            fraction: 1

class Collection extends Base.Collection
    model: (attrs, options) ->
        try
            modelType = attrs["subModelTypeAttribute"]
            model = PsychoCoffee[modelType]["Model"]
        catch error
            model = Model
        new model(attrs, options)


module.exports =
    Model: Model
    Collection: Collection