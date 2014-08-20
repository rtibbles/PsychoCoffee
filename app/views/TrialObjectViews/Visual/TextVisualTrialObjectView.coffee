'use strict'

VisualTrialObjectView = require '../VisualTrialObjectView'
Keys = require "utils/keys"

module.exports = class TextVisualTrialObjectView extends VisualTrialObjectView

    object_type:
        fabric.Text

    render: ->
        @object = new @object_type @model.returnRequired()[0],
            @model.returnOptions()
        console.log @object

    addText: (options) ->
        if "text" of options
            text = options.text
        else if "key" of options
            text = Keys.KeysToText[options.key] or options.key
            if typeof text == "string" and options.shiftKey
                console.log "True"
                text = text.toUpperCase()
        if text instanceof Function
            @object.setText text(@object.getText())
        else
            @object.setText @object.getText() + text