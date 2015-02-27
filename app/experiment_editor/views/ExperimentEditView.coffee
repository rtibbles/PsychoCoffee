'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/experimentedit'
TitleTemplate = require '../templates/experimenttitle'
Experiment = require '../models/Experiment'
BlockEditView = require './BlockEditView'
BlockListView = require './BlockListView'
ModelEditView = require './ModelEditView'
VariableEditView = require './VariableEditView'
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
            @tabViews["blockEditView"]?.remove()
            @tabViews["blockEditView"] = new BlockEditView
                model: @blockmodel
                files: @model.get("files")
            @tabViews["blockEditView"].render()
            @tabViews["blockEditView"].appendTo("#blockedit")
            @initializePreview()
            @listenTo @blockmodel, "change",
                _.throttle(@startPreview, 100)
            @listenTo @blockmodel, "nested-change",
                @frameAdvance
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
        PsychoEdit.router.editSubItem @blockmodel.get("name"), item
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
            @tabViews["variableEditView"]?.remove()
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
    
    removePreview: =>
        if @tabViews["experimentPreview"]
            @stopListening @tabViews["experimentPreview"]
            if @tabViews["experimentPreview"].close
                @tabViews["experimentPreview"].close()
            else
                @tabViews["experimentPreview"].remove()
        delete @tabViews["experimentPreview"]

    initializePreview: =>
        @frame = 0
        @removePreview()
        @tabViews["experimentPreview"] = new PsychoCoffee.ExperimentView({
            model: @model
            editor: true
        })
        @listenToOnce @tabViews["experimentPreview"], "loaded", @startPreview

    startPreview: =>
        if @trialPreview
            if @trialPreview.close?
                @trialPreview.close()
            else
                @trialPreview.remove()
        delete @trialPreview
        @trialPreview = @tabViews["experimentPreview"].previewBlock @blockmodel
        offset = $("#scrubber").offset()
        offset["top"] += $("#scrubber").height() + 5
        offset["left"] = $("#block-preview").offset()["left"]
        $("#trial-draw").offset(offset)
        @$(".play").show()
        @$(".pause").hide()
        @updateFrame()
        @trialPreview.startTrial()
        @frameAdvance()

    frameAdvance: =>
        if not @trialPreview.clock.timerStart
            @trialPreview.clock.initTimer()
        @trialPreview.clock.advanceFrame()

    playPreview: =>
        if @trialPreview.clock.pauseTimestamp
            @trialPreview.clock.resumeTimer()
        else
            @trialPreview.clock.startTimer()
        @listenTo @trialPreview.clock, "tick", @updateFrame
        @$(".play").hide()
        @$(".pause").show()

    pausePreview: =>
        @trialPreview.clock.pauseTimer()
        @$(".play").show()
        @$(".pause").hide()

    updateFrame: (frame) =>
        @frame = frame or @frame
        duration = if @blockmodel.get("timeout") != 0\
            then @blockmodel.get("timeout") else 20000
        elapsed = @frame*@trialPreview.clock.tick
        if elapsed/duration <= 1
            @animateScrubBar(elapsed/duration)
        else
            @pausePreview()

    animateScrubBar: _.throttle(
        (fraction) ->
            $(".progress-bar.scrub").css("width", 100*fraction + "%")
        , 10)

    saveExperiment: ->
        @model.save()