'use strict'

VisualTrialObjectView = require '../VisualTrialObjectView'

module.exports = class ImageVisualTrialObjectView extends VisualTrialObjectView

    render: ->
        @object = new fabric.Image @file_object