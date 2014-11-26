'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/experimentedit'
TitleTemplate = require '../templates/experimenttitle'
Experiment = require '../../models/Experiment'
BlockEditView = require './BlockEditView'
BlockListView = require './BlockListView'
ModelEditView = require './ModelEditView'
View = require './View'

class ExperimentTitleView extends View

    template: TitleTemplate

    events:
        "click .title": "editExperiment"

    initialize: ->
        @listenTo @model, "change", @render

    editExperiment: ->
        modelEditView = new ModelEditView({model: @model})
        modelEditView.render()

module.exports = class ExperimentEditView extends CodeGeneratorView
    template: Template

    initialize: ->
        @model = new Experiment.Model({
            name: "My Test Experiment"
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
        @experimentTitleView = new ExperimentTitleView({model: @model})
        @$("#experiment_info").append @experimentTitleView.el
        @experimentTitleView.render()
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