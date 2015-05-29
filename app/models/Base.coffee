'use strict'

class Model extends Backbone.AssociatedModel

    idAttribute: "_id"

    defaults: ->
        defaults = {}
        for option in @objectOptions()
            if option.default?
                defaults[option.name] = option.default
        for option in @fixedItems()
            if option.default?
                defaults[option.name] = option.default
        for parameter in @requiredParameters()
            defaults[parameter.name] = parameter.default
        for parameter in @relations or []
            value = if parameter.type is Backbone.Many then [] else {}
            defaults[parameter.key] = value
        return defaults

    requiredParameters: ->
        # Lists all parameters needed to initialize object
        # Assumes listed in order that they appear in args
        [
            name: "name"
            default: ""
            type: "String"
        ]

    objectOptions: ->
        # Lists additional parameters for object
        []

    fixedItems: ->
        #Lists uneditable parameters for the object
        []

    returnRequired: ->
        required = {}
        for parameter in @requiredParameters()
            required[parameter.name] = @get(parameter.name)
        return required

    returnOptions: ->
        options = {}
        for option in @objectOptions()
            if @get(option.name)?
                options[option.name] = @get option.name
        return options

    allParameters: ->
        parameters = {}
        for parameter in @objectOptions().concat(@requiredParameters()).concat(
            @fixedItems())
            if @get(parameter.name)?
                parameters[parameter.alias or
                    parameter.name] = @get parameter.name
        return parameters

    allParameterNames: ->
        parameter.name for parameter in @objectOptions().concat(
            @requiredParameters())

    allAliasNames: ->
        parameter.alias or parameter.name for parameter in @objectOptions()
            .concat(@requiredParameters())
            .concat(@fixedItems())

    aliasMap: ->
        map = {}
        for parameter in @objectOptions().concat(@requiredParameters())
            if parameter.alias
                map[parameter.alias] = parameter.name
        return map

    setFromObject: (object, omit=[]) ->
        attrs = _.pick(object, @allAliasNames())
        for alias, name of @aliasMap()
            if alias of attrs
                attrs[name] = attrs[alias]
                delete attrs[alias]
        for key, value of attrs
            if value == @get key
                delete attrs[key]
        attrs = _.omit(attrs)
        @set attrs

    methods: ->
        []

    name: ->
        @get("name") or @id

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

class Collection extends Backbone.Collection
    url: "none"
    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
