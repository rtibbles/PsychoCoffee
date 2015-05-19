'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/experimentedit'
TitleTemplate = require '../templates/experimenttitle'
Experiment = require '../models/Experiment'
BlockEditView = require './BlockEditView'
BlockListView = require './BlockListView'
ModelEditView = require './ModelEditView'
VariableEditView = require './VariableEditView'
FileManagerView = require './FileManagerView'
View = require './View'

class ExperimentTitleView extends View

    template: TitleTemplate

    events:
        "click .title": "editExperiment"

    initialize: ->
        @listenTo @model, "change:name", @render

    editExperiment: ->
        modelEditView = new ModelEditView({model: @model})
        modelEditView.render()

module.exports = class ExperimentEditView extends CodeGeneratorView
    template: Template

    events:
        "click .play": "playPreview"
        "click .pause": "pausePreview"
        "click #save_experiment": "saveExperiment"
        "click .variables-tab": "variables"
        "click .blocks-tab": "blocks"
        "click .files-tab": "files"

    initialize: (options) ->
        @model_id = options.model_id
        @model = new Experiment.Model _id: @model_id
        @model.fetch().success =>
            @render()
        @tabViews = {}
    
    render: ->
        super
        PsychoEdit.files = @model.get("files")
        @experimentTitleView = new ExperimentTitleView({model: @model})
        @$("#experiment_info").append @experimentTitleView.el
        @experimentTitleView.render()
        @blockListView = new BlockListView({collection: @model.get("blocks")})
        @$("#blocks-container").append @blockListView.el
        @blockListView.render()
        @rendered = true
        @trigger "rendered"

    editBlock: (model_id) ->
        if @rendered
            @showEditBlock(model_id)
        else
            @listenToOnce @, "rendered", => @showEditBlock(model_id)

    showEditBlock: (model_id) =>
        for key, value of @tabViews
            value?.$el.hide()
        model = @model.get("blocks").get(model_id)
        new_model_check = model != @blockmodel
        no_view_check = not @blockEditView?
        if new_model_check or no_view_check
            @blockmodel = model
            @tabViews["blockEditView"]?.close()
            @tabViews["blockEditView"] = new BlockEditView
                model: @blockmodel
                experiment: @model
                files: @model.get("files")
            @tabViews["blockEditView"].render()
            @tabViews["blockEditView"].appendTo("#blockedit")
        else
            @tabViews["blockEditView"]?.$el.show()
            @tabViews["experimentPreview"]?.$el.show()
        if not @$(".blocks-tab").hasClass("active")
            @$(".block-nav li").removeClass("active")
            @$(".blocks-tab").addClass("active")


    variables: ->
        @subItemRoute("variables")

    blocks: ->
        @subItemRoute("blocks")

    files: ->
        @subItemRoute("files")

    subItemRoute: (item) ->
        PsychoEdit.router.editSubItem @blockmodel?.get("name"), item
        return false

    editVariables: (block_id) ->
        if @rendered
            @showEditVariables(block_id)
        else
            @listenToOnce @, "rendered", => @showEditVariables(block_id)

    showEditVariables: (block_id) =>
        for key, value of @tabViews
            value?.$el.hide()
        model = @model.get("blocks").get(block_id)
        new_model_check = model != @blockmodel
        no_view_check = not @tabViews["variableEditView"]?
        if new_model_check or no_view_check
            @blockmodel = model
            @tabViews["variableEditView"]?.close()
            @tabViews["variableEditView"] = new VariableEditView
                model: @model
                blockmodel: @blockmodel
            @tabViews["variableEditView"].render()
            @tabViews["variableEditView"].appendTo("#blockedit")
        else
            @tabViews["variableEditView"]?.$el.show()
        if not @$(".variables-tab").hasClass("active")
            @$(".block-nav li").removeClass("active")
            @$(".variables-tab").addClass("active")

    editFiles: (block_id) ->
        if @rendered
            @showEditFiles(block_id)
        else
            @listenToOnce @, "rendered", => @showEditFiles(block_id)

    showEditFiles: (block_id) =>
        for key, value of @tabViews
            value?.$el.hide()
        model = @model.get("blocks").get(block_id)
        new_model_check = model != @blockmodel
        no_view_check = not @tabViews["fileView"]?
        if new_model_check or no_view_check
            @blockmodel = model
            @tabViews["fileView"]?.close()
            @tabViews["fileView"] = new FileManagerView
                model: @model
                blockmodel: @blockmodel
            @tabViews["fileView"].render()
            @tabViews["fileView"].appendTo("#blockedit")
        else
            @tabViews["fileView"]?.$el.show()
        if not @$(".files-tab").hasClass("active")
            @$(".block-nav li").removeClass("active")
            @$(".files-tab").addClass("active")
    
    saveExperiment: ->
        @model.save()