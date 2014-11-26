'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/experimentedit'
Experiment = require '../../models/Experiment'
BlockEditView = require './BlockEditView'
BlockListView = require './BlockListView'

module.exports = class ExperimentEditView extends CodeGeneratorView
    template: Template

    initialize: ->
        @model = new Experiment.Model
        @listenTo @global_dispatcher, "editBlock", @editBlock
    
    render: ->
        super
        @blockListView = new BlockListView({collection: @model.get("blocks")})
        @blockListView.render()
        @$("#blocks-container").append @blockListView.el
    
    editBlock: (model) ->
        if model != @blockmodel
            @blockmodel = model
            @blockEditView?.remove()
            @blockEditView = new BlockEditView({model: @blockmodel})
            @blockEditView.render()
            @blockEditView.appendTo("#blockedit")