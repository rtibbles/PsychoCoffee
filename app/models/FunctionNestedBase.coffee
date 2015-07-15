'use strict'

NestedBase = require './NestedBase'

class Model extends NestedBase.Model

    initialize: ->
        @parseAllListeners()
        @listenTo @, "change:__listeners", @parseAllListeners

    get: (attr) =>
        value = super(attr)
        if _.isFunction(value)
            try
                value = value.call(@)
            catch e
                value = @defaults[attr]
        return value

    set: (key, val, options) =>
        if not key then return @

        if typeof key == 'object'
            for attr_key, attr_val of key
                key[attr_key] = @transformFunction(attr_val)
        else
            val = @transformFunction(val)

        super key, val, options

        listeners = options?.listeners or val?.listeners or []

        if listeners.length > 0
            console.log listeners
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

    toJSON: (options) =>
        attrs = _.clone(@attributes)
        for key, value of attrs
            if _.isFunction value
                attrs[key] = value.toString()
        return attrs

    parse: (resp, options) ->
        for key, value of resp
            resp[key] = @transformFunction(value)
        return resp

    transformFunction: (value) ->
        # Only try to transform Strings into Functions
        # Otherwise either not a String of a Function
        # Or is a Function already
        if not _.isString value then return value
        try
            out = Function("return #{value}")()
        catch e
            out = ""
        if _.isFunction out then return out else return value

class Collection extends NestedBase.Collection

    model: Model

module.exports =
    Model: Model
    Collection: Collection