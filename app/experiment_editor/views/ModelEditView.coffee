'use strict'

ModalView = require './ModalView'

module.exports = class ModelEditView extends ModalView

    events:
        "click .save": "setAttributes"

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
            @remove()