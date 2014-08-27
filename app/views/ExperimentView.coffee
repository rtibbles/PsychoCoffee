'use strict'

clock = require("utils/clock")
HandlerView = require './HandlerView'
Experiment = require '../models/Experiment'
ExperimentDataHandler = require '../models/ExperimentDataHandler'
Template = require 'templates/experiment'
ProgressBarView = require './ProgressBarView'
stringHash = require 'utils/stringHash'
fingerprint = require 'utils/fingerprint'
random = require 'utils/random'

module.exports = class ExperimentView extends HandlerView
    template: Template

    initialize: =>
        super
        @user_id = stringHash(fingerprint())
        random.seedGUID fingerprint()
        @clock = new clock.Clock()
        @refreshTime()
        @render()
        @appendTo("#app")
        @datacollection = new ExperimentDataHandler.Collection
            experiment_identifier: @model.get("identifier")
            participant_id: @user_id
        @datacollection.filterFetch().then =>
            @datamodel = @datacollection.getOrCreateParticipantModel(@user_id,
                @model)
            console.log @datamodel.get("start_time")?
            @instantiateSubViews("blocks", "BlockView")
            @preLoadExperiment()

    refreshTime: =>
        @time = @clock.getTime()

    preLoadExperiment: ->
        queue = new createjs.LoadQueue true
        for key, view of @subViews
            view.preLoadBlock(queue)
        progressBarView = new ProgressBarView
            queue: queue
            complete: @startExperiment
        progressBarView.appendTo("#messages")
        progressBarView.render()
        
    startExperiment: =>
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
        blockView = @subViews[block.get("id")]
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


    nextBlock: ->
        @datamodel.set("block", @datamodel.get("block") + 1)
        currentBlock = @model.get("blocks").at(@datamodel.get("block"))
        @showBlock currentBlock

    endExperiment: =>
        date_time = new Date().getTime()
        @logEvent "experiment_end", date_time: date_time
        @datamodel.set "end_time", date_time
        @datamodel.set "complete", true
        console.log ("I am done here!")