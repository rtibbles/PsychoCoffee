'use strict'

Template = require '../templates/blockmodeledit'
ModalView = require './ModalView'

module.exports = class BlockModelEditView extends ModalView
    template: Template

    events:
        "click .save": "setAttributes"

    setAttributes: ->
        attrs = {}
        ready = true
        for item in @$("input")
            attrs[item.id] = item.value
            if item.required != "" and item.value == ""
                @$(item).css("border", "2px solid red")
                ready = false
        if ready
            @model.set attrs
            @remove()