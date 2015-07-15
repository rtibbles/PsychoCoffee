'use strict'

nestedModules = require '../utils/nestedModules'

FunctionNestedBase = require './FunctionNestedBase'

class Model extends FunctionNestedBase.Model

    fileAttr: "file"

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
            name: "activated"
        ,
            name: "deactivated"
        ]

    methods: ->
        super().concat([
            name: "activate"
        ,
            name: "deactivate"
        ])


class Collection extends FunctionNestedBase.Collection
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