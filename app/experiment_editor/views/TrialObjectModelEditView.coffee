'use strict'

Template = require '../templates/trialobjectmodeledit'
ModelEditView = require './ModelEditView'

module.exports = class TrialObjectModelEditView extends ModelEditView
    template: Template

    getRenderData: ->
        required = (_.extend(value: @model.get(param.name),
            param) for param in @model.requiredParameters())
        options = (_.extend(value: @model.get(param.name),
            param) for param in @model.objectOptions())
        data =
            required: required
            options: options
    