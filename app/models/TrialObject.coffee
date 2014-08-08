'use strict'

nestedModules = require '../utils/nestedModules'

Base = require('./Base')

subModels = {}
for modulename in nestedModules('models/TrialObjects')
    subModels[modulename] = modulename + ".Model"

class Model extends Base.Model
    subModelTypes: subModels


    defaults: ->
        delay: 0
        duration: 5

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