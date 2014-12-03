'use strict'

clock = require("utils/clock")
HandlerView = require './HandlerView'
Experiment = require '../models/Experiment'
ExperimentDataHandler = require '../models/ExperimentDataHandler'
Template = require 'templates/experiment'
ProgressBarView = require './ProgressBarView'
stringHash = require 'utils/stringHash'
fingerprint = require 'utils/fingerprint'
urlParse = require 'utils/urlParse'

module.exports = class ExperimentView extends HandlerView
    template: Template

    initialize: (options) =>
        super
        # Flag to allow the views to behave differently under
        # editing conditions
        if options.editor
            @editor = true
        @urlParams = urlParse.decodeGetParams(window.location.href)
        # This sets the User ID depending on the way that the experiment
        # is being run, also collects other relevant information for
        # different subject pool conditions.
        switch @model?.get("subjectPool")
            when "AMT"
                @user_id = @urlParams.workerId
                @assignment_id = @urlParams.assignmentId
                @turkSubmitTo = @urlParams.turkSubmitTo
                @hitId = @urlParams.hitId
            else
                @user_id = stringHash(fingerprint())
        @blockSelector = options.selector or @defaultNextBlock
        @clock = new clock.Clock()
        @refreshTime()
        @render()
        @appendTo("#app")
        @datacollection = new ExperimentDataHandler.Collection
            experiment_identifier: @model?.get("identifier")
            participant_id: @user_id
        if not @editor
            @datacollection.filterFetch().then =>
                @dataCollectionInitialized()
        else
            @dataCollectionInitialized()


    dataCollectionInitialized: =>
        @datamodel = @datacollection.getOrCreateParticipantModel(@user_id,
            @model)
        @datamodel.set("parameters", @datamodel.get("parameters") or
            @model.returnParameters(@user_id))
        window.Variables = @datamodel.get("parameters")
        if @model.get("subjectPool") == "AMT"
            @datamodel.set
                assignment_id: @assignment_id
                turkSubmitTo: @turkSubmitTo
                hitId: @hitId
        @instantiateSubViews(
            "blocks"
            "BlockView"
            null
            parameters: @datamodel.get("parameters"))
        @preLoadExperiment()

    refreshTime: =>
        @time = @clock.getTime()

    preLoadExperiment: ->
        queue = new createjs.LoadQueue true
        for key, view of @subViews
            view.preLoadBlock(queue)
        @progressBarView = new ProgressBarView
            queue: queue
            complete: @startExperiment
        @progressBarView.appendTo("#messages")
        @progressBarView.render()
        
    startExperiment: =>
        if not @editor
            date_time = new Date().getTime()
            if @datamodel.get("start_time")?
                @logEvent "experiment_resume", date_time: date_time
            else
                @datamodel.set "start_time", date_time
                @logEvent "experiment_start", date_time: date_time
            @datamodel.set("block", @datamodel.get("block") or 0)
            currentBlock = @model.get("blocks").at(@datamodel.get("block"))
            @showBlock currentBlock

    showBlock: (block) =>
        if not block
            @endExperiment()
            return
        blockView = @subViews[block.id]
        if @blockView
            if @blockView.close then @blockView.close() else @blockView.remove()
        @blockdatamodel =
            @datamodel.get("blockdatahandlers").at(@datamodel.get("block")) or
            @datamodel.get("blockdatahandlers").create()
        @datamodel.save()
        @blockView = blockView
        @blockView.datamodel = @blockdatamodel
        @blockView.render()
        @listenToOnce @blockView, "blockEnded", @nextBlock
        @blockView.startBlock()

    previewBlock: (block) =>
        blockView = @subViews[block.id]
        if @blockView
            if @blockView.close then @blockView.close() else @blockView.remove()
        @blockdatamodel =
            @datamodel.get("blockdatahandlers").add({})
        @blockView = blockView
        @blockView.datamodel = @blockdatamodel
        @blockView.render()
        @blockView.previewBlock()

    defaultNextBlock: (blocks, blocknumber) ->
        blocknumber + 1

    nextBlock: ->
        @datamodel.set("block",
            @trialSelector(@model.get("blocks"), @datamodel.get("block")))
        currentBlock = @model.get("blocks").at(@datamodel.get("block"))
        @showBlock currentBlock

    endExperiment: =>
        date_time = new Date().getTime()
        @logEvent "experiment_end", date_time: date_time
        @datamodel.set "end_time", date_time
        @datamodel.set "complete", true
        @datamodel.save null,
            now: true
            success: =>
                console.log "I'm done here!"
                @$("#messages").html("<h1>Experiment Complete - Thank you</h1>")