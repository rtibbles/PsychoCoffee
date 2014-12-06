'use strict'

ModalView = require './ModalView'
FileUploadView = require './FileUploadView'
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

    render: ->
        super
        subViews = {}
        for item in @$("input[type=file]")
            console.log item.id
            subViews[item.id] = new FileUploadView({
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
            if item.required and attrs[item.id] == ""
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
            deleteable: @deleteable
            required: required
            options: options
            name: @model.get("name")