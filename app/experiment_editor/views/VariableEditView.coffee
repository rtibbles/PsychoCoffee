'use strict'

View = require './View'
ParameterSetEditView = require './ParameterSetEditView'
Template = require '../templates/variableedit'

module.exports = class VariableEditView extends View
    template: Template

    events:
        "click .save": "setAttributes"
        "click .cancel": "cancelEdit"

    initialize: (options) ->
        super
        @blockmodel = options.blockmodel

    render: ->
        super
        @experimentParameterView = new ParameterSetEditView
            model: @model
            type: "experiment"
        @experimentParameterView.render()
        @$("#variables").append @experimentParameterView.el
        if @blockmodel?
            @trialParameterView = new ParameterSetEditView
                model: @blockmodel
                type: "trial"
            @trialParameterView.render()
            @$("#variables").append @trialParameterView.el
        @$(".collapse").collapse()

    setAttributes: ->
        @remove()

    cancelEdit: ->
        @remove()