'use strict'

ModalView = require './ModalView'
ParameterSetEditView = require './ParameterSetEditView'
Template = require '../templates/variableedit'

module.exports = class VariableEditView extends ModalView
    template: Template

    events:
        "click .save": "setAttributes"
        "click .cancel": "cancelEdit"

    initialize: (options) ->
        super
        @blockmodel = options.blockmodel

    render: ->
        super
        @experimentParameterView = new ParameterSetEditView
            model: @model
            type: "experiment"
        @experimentParameterView.render()
        @$("#accordion").append @experimentParameterView.el
        if @blockmodel?
            @trialParameterView = new ParameterSetEditView
                model: @blockmodel
                type: "trial"
            @trialParameterView.render()
            @$("#accordion").append @trialParameterView.el
        @$(".collapse").collapse()


    setAttributes: ->
        attrs = {}
        ready = true
        for item in @$("input, span.fileinput")
            attrs[item.id] = item.value or @$(item).attr("value")
            if @validators[item.id]?
                valid = @validators[item.id](attrs[item.id])
            if (item.required and attrs[item.id] == "") or not valid
                message =
                    if valid then "required" else "duplicate"
                @$(item).css("border", "2px solid red").popover
                    content: "<span class='label label-warning'>
                        #{message}</span>"
                    trigger: 'focus'
                    html: true
                @$(item).popover('show')
                ready = false
        if ready
            @model.set attrs
            @model.new = false
            @trigger "attributes_set"
            @remove()

    getRenderData: ->
        required = (_.extend(
            value: @model.get(param.name)
            required: true,
            param) for param in @model.requiredParameters())
        options = (_.extend(value: @model.get(param.name),
            param) for param in @model.objectOptions())
        data =
            deleteable: @deleteable
            required: required
            options: options
            name: @model.get("name")