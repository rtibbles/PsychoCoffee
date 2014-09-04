'use strict'

nestedModules = require '../utils/nestedModules'


Base = require('./Base')

class Model extends Base.Model

    defaults: ->
        defaults = {}
        for option in @objectOptions()
            if option.default?
                defaults[option.name] = option.default
        for parameter in @requiredParameters()
            defaults[parameter.name] = parameter.default
        return defaults

    requiredParameters: ->
        # Lists all parameters needed to initialize object
        # Assumes listed in order that they appear in args
        []

    objectOptions: ->
        # Lists additional parameters for object
        [
            name: "delay"
            default: 0
            type: "number"
        ,
            name: "duration"
            default: 0
            type: "number"
        ,
            name: "startWithTrial"
            default: true
            type: "boolean"
        ,
            name: "parameterizedAttributes"
            default: {}
            type: "object"
        ,
            ###
            Triggers are objects of the form -
            { eventName: "change", objectName: "firstImage",
            callback: "firstImageMethod", arguments: {size: 17}}
            The trigger will be registered to listen to this event
            on the other trial object, and will invoke this callback
            with these arguments. An optional argument of "once" can be
            set to true to use listenToOnce instead of listenTo.
            ###
            name: "triggers"
            default: []
            type: "array"
            embedded_type: Object
        ]

    parameterizedTrial: (parameters) ->
        attributes = _.clone @attributes
        for attribute, parameterName of @get "parameterizedAttributes"
            if parameterName of parameters
                # This allows parameters to be undefined without breaking
                # the experiment - can be used to dynamically parameterize
                # trials, e.g. by having them parameterized in some
                # conditions but not others
                attributes[attribute] = parameters[parameterName]
        return attributes

    returnRequired: ->
        required = []
        for parameter in @requiredParameters()
            required.push @get(parameter.name)
        return required

    returnOptions: ->
        options = {}
        for option in @objectOptions()
            if @get(option.name)?
                options[option.name] = @get option.name
        return options

    allParameters: ->
        parameters = {}
        for parameter in @objectOptions().concat @requiredParameters()
            if @get(parameter.name)?
                parameters[parameter.alias or
                    parameter.name] = @get parameter.name
        return parameters


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