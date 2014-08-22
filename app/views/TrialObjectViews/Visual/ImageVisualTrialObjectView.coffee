'use strict'

VisualTrialObjectView = require '../VisualTrialObjectView'

module.exports = class ImageVisualTrialObjectView extends VisualTrialObjectView

    render: ->
        if not @object
            @object = new fabric.Image @file_object, @model.returnOptions()
        super