'use strict'

ModalView = require './ModalView'
FileManagerView = require './FileManagerView'
Template = require '../templates/modeledit'

module.exports = class ModelEditView extends ModalView
    template: Template

    events:
        "click .save": "setAttributes"
        "click .cancel": "cancelEdit"
        "click .delete": "deleteModel"

    initialize: (options) ->
        super
        @deleteable = options.deleteable
        @validators = options.validators or {}

    render: ->
        super
        subViews = {}
        for item in @$("input[type=file]")
            subViews[item.id] = new FileManagerView({
                single: true
                field_id: item.id
            })
            subViews[item.id].render()
            $(item).replaceWith(subViews[item.id].el)
    deleteModel: ->
        @model.destroy()
        @remove()

    cancelEdit: ->
        if @model.new
            @model.destroy()
        @remove()

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