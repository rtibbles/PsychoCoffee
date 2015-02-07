'use strict'

random = require 'utils/random'

class Model extends Backbone.AssociatedModel
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

    setFromObject: (object) ->
        attrs = _.pick(object, @allAliasNames())
        for alias, name of @aliasMap()
            if alias of attrs
                attrs[name] = attrs[alias]
                delete attrs[alias]
        @set attrs

    methods: ->
        []

    name: ->
        @get("name") or @id

class Collection extends Backbone.Collection
    url: "none"
    local: true
    model: Model

module.exports =
    Model: Model
    Collection: Collection
