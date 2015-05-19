'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/blockedit'
ToolbarTemplate = require '../templates/trialobjecttoolbar'
ListTemplate = require '../templates/trialobjectlist'
ItemTemplate = require '../templates/trialobjectlistitem'
ModelEditView = require './ModelEditView'
BlocklyView = require './BlocklyView'
View = require './View'
DraggableView = require './DraggableView'

class TrialObjectToolbarView extends View
    template: ToolbarTemplate

    getRenderData: ->
        return trialObjects: PsychoEdit.trialObjects


class TrialObjectItemView extends DraggableView
    template: ItemTemplate

    events:
        "click .trialObject": "editTrialObject"

    editTrialObject: (event) ->
        editView = new ModelEditView
            model: @model
            deleteable: true
        editView.render()

    initialize: ->
        super
        @render()
        @listenTo @model, "change", @render

class TrialObjectListView extends View
    template: ListTemplate

    initialize: ->
        @listenTo @collection, "add", @render
        @listenTo @collection, "remove", @render

    render: ->
        super
        for model in @collection.models
            view = new TrialObjectItemView model: model
            @$(".trialObjectList").append view.el


module.exports = class BlockEditView extends CodeGeneratorView
    template: Template

    events:
        "click .addtrialobject": "addTrialObject"
    
    initialize: (options) ->
        super
        @files = options.files
        @experiment = options.experiment

    render: ->
        super
        @listenToOnce @global_dispatcher, "psych_loaded", @initializePreview
        @toolbarView = new TrialObjectToolbarView
        @blocklyView = new BlocklyView
            model: @model
            el: @$("#block-code")
        @listenToOnce @blocklyView, "blockly_ready", @blocklyObjects
        @blocklyView.render()
        @listenTo @blocklyView, "change", @generateCode
        @$("#new_models").prepend @toolbarView.el
        @toolbarView.render()

    blocklyObjects: =>
        for model, i in @model.get("trialObjects").models
            @blocklyView.insertModelBlock model, i
        @blocklyView.insertModelBlocks(@model.get("trialObjects"),
                "Trial Objects")
        @blocklyView.addDataModel("TrialDataHandler")
        @blocklyView.addClockBlocks()
        @blocklyView.insertBlocklyXML()

    addTrialObject: (event) ->
        subModel = event.target.id
        @newTrialObject = @model.get("trialObjects").add({
            subModelTypeAttribute: subModel
        })
        @newTrialObject.new = true
        modelEditView = new ModelEditView
            model: @newTrialObject
            validators:
                name: (name) =>
                    not (name and @model.get("trialObjects").get(name)?)
        modelEditView.render()
        @listenTo @newTrialObject, "change:name", @addModelToBlockly

    addModelToBlockly: =>
        @blocklyView.insertModelBlock @newTrialObject

    generateCode: =>
        @model.set "flow", new Function(@blocklyView.generateCode())

    initializePreview: (PsychoCoffee) =>
        @PsychoCoffee = PsychoCoffee
        @frame = 0
        @subViews["experimentPreview"] = new @PsychoCoffee.ExperimentView({
            model: @experiment
            editor: true
        })
        @listenToOnce @subViews["experimentPreview"], "loaded", @createPreview

    createPreview: =>
        if @subViews["trialPreview"]
            if @subViews["trialPreview"].close?
                @subViews["trialPreview"].close()
            else
                @subViews["trialPreview"].remove()
        delete @subViews["trialPreview"]
        @subViews["trialPreview"] =
            @subViews["experimentPreview"].previewBlock @model
        @startPreview()
        @listenTo @model, "change",
            _.debounce(@startPreview, 500)
        @listenTo @model, "nested-change",
            @frameAdvance
    
    startPreview: =>
        @$(".play").show()
        @$(".pause").hide()
        @updateFrame()
        @subViews["trialPreview"].startTrial()
        @frameAdvance()

    frameAdvance: =>
        if not @subViews["trialPreview"].clock.timerStart
            @subViews["trialPreview"].clock.initTimer()
        @subViews["trialPreview"].clock.advanceFrame()

    playPreview: =>
        if @subViews["trialPreview"].clock.pauseTimestamp
            @subViews["trialPreview"].clock.resumeTimer()
        else
            @subViews["trialPreview"].clock.startTimer()
        @listenTo @subViews["trialPreview"].clock, "tick", @updateFrame
        @$(".play").hide()
        @$(".pause").show()

    pausePreview: =>
        @subViews["trialPreview"].clock.pauseTimer()
        @$(".play").show()
        @$(".pause").hide()

    updateFrame: (frame) =>
        @frame = frame or @frame
        duration = if @model.get("timeout") != 0\
            then @model.get("timeout") else 20000
        elapsed = @frame*@subViews["trialPreview"].clock.tick
        if elapsed/duration <= 1
            @animateScrubBar(elapsed/duration)
        else
            @pausePreview()

    animateScrubBar: _.throttle(
        (fraction) ->
            $(".progress-bar.scrub").css("width", 100*fraction + "%")
        , 10)