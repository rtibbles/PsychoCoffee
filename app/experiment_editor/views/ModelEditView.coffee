'use strict'

ModalView = require './ModalView'

module.exports = class ModelEditView extends ModalView

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
            if not item.required? and item.value == ""
                @$(item).css("border", "2px solid red")
                ready = false
        if ready
            @model.set attrs
            @model.new = false
            @remove()