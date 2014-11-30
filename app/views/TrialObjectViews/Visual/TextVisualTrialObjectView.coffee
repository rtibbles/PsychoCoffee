'use strict'

VisualTrialObjectView = require '../VisualTrialObjectView'
Keys = require "utils/keys"

module.exports = class TextVisualTrialObjectView extends VisualTrialObjectView

    object_type:
        fabric.Text

    render: ->
        if not @object
            @object = new @object_type @model.get("text"),
                @model.returnOptions()
        super

    addText: (options) ->
        if "text" of options
            text = options.text
        else if "key" of options
            text = Keys.KeysToText[options.key] or options.key
            if typeof text == "string" and options.shiftKey
                text = text.toUpperCase()
        if text instanceof Function
            @model.set("text", text(@model.get("text")))
        else
            @model.set("text", @model.get("text") + text)