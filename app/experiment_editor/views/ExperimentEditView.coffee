'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/experimentedit'
Experiment = require '../../models/Experiment'
BlockEditView = require './BlockEditView'
BlockListView = require './BlockListView'

module.exports = class ExperimentEditView extends CodeGeneratorView
    template: Template

    initialize: ->
        @model = new Experiment.Model({
            blocks: [
                {
                    name: "this"
                    trialObjects: [
                        {
                            name: "audioTest"
                            subModelTypeAttribute: "AudioTrialObject"
                        },
                        {
                            name: "audioTest2"
                            subModelTypeAttribute: "AudioTrialObject"
                        }
                    ]
                }
            ]
            })
        @listenTo @global_dispatcher, "editBlock", @editBlock
        @appendTo("#editor_window")
        @render()
    
    render: ->
        super
        @blockListView = new BlockListView({collection: @model.get("blocks")})
        @$("#blocks-container").append @blockListView.el
        @blockListView.render()
    
    editBlock: (model) ->
        if model != @blockmodel
            @blockmodel = model
            @blockEditView?.remove()
            @blockEditView = new BlockEditView({model: @blockmodel})
            @blockEditView.render()
            @blockEditView.appendTo("#blockedit")