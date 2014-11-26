'use strict'

ModalView = require './ModalView'
Template = require '../templates/modeledit'

module.exports = class ModelEditView extends ModalView
    template: Template

    events:
        "click .save": "setAttributes"
        "click .cancel": "cancelEdit"
        "click .delete": "deleteModel"

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
        for item in @$("input")
            attrs[item.id] = item.value
            if item.required and item.value == ""
                @$(item).css("border", "2px solid red").popover
                    content: "<span class='label label-warning'>
                        required</span>"
                    trigger: 'focus'
                    html: true
                @$(item).popover('show')
                ready = false
        if ready
            @model.set attrs
            @model.new = false
            @remove()

    getRenderData: ->
        required = (_.extend(
            value: @model.get(param.name)
            required: true,
            param) for param in @model.requiredParameters())
        options = (_.extend(value: @model.get(param.name),
            param) for param in @model.objectOptions())
        data =
            required: required
            options: options
            name: @model.get("name")