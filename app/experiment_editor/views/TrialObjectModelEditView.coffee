'use strict'

Template = require '../templates/trialobjectmodeledit'
ModalView = require './ModalView'

module.exports = class TrialObjectModelEditView extends ModalView
    template: Template

    getRenderData: ->
        required = (_.extend(value: @model.get(param.name),
            param) for param in @model.requiredParameters())
        options = (_.extend(value: @model.get(param.name),
            param) for param in @model.objectOptions())
        data =
            required: required
            options: options
    