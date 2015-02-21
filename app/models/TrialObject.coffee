'use strict'

nestedModules = require '../utils/nestedModules'

NestedBase = require './NestedBase'

class Model extends NestedBase.Model

    initialize: ->
        @parseAllListeners()
        @listenTo @, "change:__listeners", @parseAllListeners

    get: (attr) ->
        value = super(attr)
        if _.isFunction(value)
            try
                value = value.call(@)
            catch e
                value = @defaults[attr]
        return value

    toJSON: (options) =>
        attrs = _.clone(@attributes)
        for key, value of attrs
            if _.isFunction value
                attrs[key] = value.toString()
        return attrs

    parse: (resp, options) ->
        for key, value of resp
            try
                out = Function(value)()
            catch e
                true
            if _.isFunction out
                resp[key] = out
        return resp

    setFunction: (key, val, options) =>
        if not key then return @
 
        if typeof key == 'object'
            throw new Error(
                "setFunction can only set single key/value pairs at this time")

        @set key, val, options

        listeners = options.listeners or []

        @setListeners key, listeners
        @parseListeners key, listeners

    setListeners: (key, listeners) =>
        store = @get("__listeners") or {}
        store[key] = listeners
        @set "__listeners", store, silent: true

    parseAllListeners: =>
        @stopListening()
        @listenList = {}
        for key, value of @get("__listeners") or {}
            @parseListeners(key, value)

    parseListeners: (key, listeners) =>
        for listener in listeners
            object = window
            trigger = listener.trigger
            if listener.path? and trigger?
                for slug in listener.path
                    object = object[slug]
                @listenTo object, trigger, =>
                    @trigger "change:" + key
                if not listenList[key]?
                    listenList[key] = []
                @listenList[key].push [object, trigger]


    objectOptions: ->
        # Lists additional parameters for object
        super().concat(
            [
                name: "delay"
                default: 0
                type: "Number"
            ,
                name: "duration"
                default: 0
                type: "Number"
            ,
                name: "startWithTrial"
                default: true
                type: "Boolean"
            ])

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

    triggers: ->
        [
            "activated"
        ,
            "deactivated"
        ]

    methods: ->
        super().concat([
            "activate"
        ,
            "deactivate"
        ])


class Collection extends NestedBase.Collection
    model: (attrs, options) ->
        try
            modelType = attrs["subModelTypeAttribute"] or
                PsychoCoffee.trialObjectTypeKeys[attrs["type"]]
            model = PsychoCoffee[modelType]["Model"]
            if PsychoCoffee[modelType]["Type"]?
                attrs["type"] = PsychoCoffee[modelType]["Type"]
        catch error
            model = Model
        new model(attrs, options)


module.exports =
    Model: Model
    Collection: Collection