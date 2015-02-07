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

    events:
        "click .play": "playPreview"
        "click .pause": "pausePreview"
        "click #save_experiment": "saveExperiment"

    initialize: ->
        @listenTo @global_dispatcher, "editBlock", @editBlock
        @appendTo("#editor_window")
        @render()
    
    render: ->
        super
        PsychoEdit.files = @model.get("files")
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
            @blockEditView = new BlockEditView
                model: @blockmodel
                files: @model.get("files")
            @blockEditView.render()
            @blockEditView.appendTo("#blockedit")
            @initializePreview()
            @listenTo @blockmodel, "change",
                _.throttle(@startPreview, 5000)
            @listenTo @blockmodel, "nested-change",
                @frameAdvance
    
    initializePreview: =>
        @frame = 0
        if @experimentPreview
            if @experimentPreview.close
                @experimentPreview.close()
            else
                @experimentPreview.remove()
        delete @experimentPreview
        @experimentPreview = new PsychoCoffee.ExperimentView({
            model: @model
            editor: true
        })
        @listenToOnce @experimentPreview, "loaded", @startPreview

    startPreview: =>
        if @trialPreview
            if @trialPreview.close?
                @trialPreview.close()
            else
                @trialPreview.remove()
        delete @trialPreview
        @trialPreview = @experimentPreview.previewBlock @blockmodel
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