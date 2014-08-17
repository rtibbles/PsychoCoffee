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
        duration: 5000
        startWithTrial: true
        parameterizedAttributes: {}
        ###
        Triggers are objects of the form -
        { eventName: "change", objectName: "firstImage",
        callback: "firstImageMethod", arguments: {size: 17}}
        The trigger will be registered to listen to this event
        on the other trial object, and will invoke this callback
        with these arguments. An optional argument of "once" can be
        set to true to use listenToOnce instead of listenTo.
        ###
        triggers: []

    parameterizedTrial: (parameters) ->
        attributes = _.clone @attributes
        for attribute, parameterName of @get "parameterizedAttributes"
            attributes[attribute] = parameters[parameterName]
        return attributes

    setParameter: (attribute, parameter) ->
        @set "parameterizedAttributes",
            @get("parameterizedAttributes")[attribute] = parameter

class Collection extends Base.Collection
    model: (attrs, options) ->
        try
            modelType = attrs["subModelTypeAttribute"] or
                PsychoCoffee.trialObjectTypeKeys[attrs["type"]]

            model = PsychoCoffee[modelType]["Model"]
        catch error
            model = Model
        new model(attrs, options)


module.exports =
    Model: Model
    Collection: Collection