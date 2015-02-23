'use strict'

View = require './View'
Template = require '../templates/parameterset'

module.exports = class ParameterSetEditView extends View
    template: Template

    initialize: (options) ->
        @type = options.type
        @collection = @model.get("parameterSet").get(@type + "Parameters")

    getRenderData: ->
        type: @type
        parameters: @collection.models
        title: @type + " variables"
        description: @getDescription()
        rows: @generateRows()

    generateRows: ->
        rows = []
        # Set a dummy max_length to force generation of some empty rows.
        max_length = 5
        for model in @collection.models
            length = model.get("parameters").length
            max_length = if length > max_length then length else max_length
        for i in [0..max_length]
            row = []
            for model in @collection.models
                parameter = model.get("parameters")[i]
                row.push
                    value: parameter or ""
                    null: not parameter?
                    parameterName: model.get("parameterName")
            row.push
                value: ""
                null: true
                parameterName: ""
            rows.push row
        return rows

    getDescription: ->
        switch @type
            when "experiment"
                "These variables will be randomized across participants - \
                each participant will only see one of these possible values"
            when "trial"
                "These variables will be randomized within participants - \
                each participant will see some or all of these possible values"