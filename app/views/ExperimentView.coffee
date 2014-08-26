'use strict'

clock = require("utils/clock")
View = require './View'
Experiment = require '../models/Experiment'
ExperimentDataHandler = require '../models/ExperimentDataHandler'
Template = require 'templates/experiment'
ProgressBarView = require './ProgressBarView'
stringHash = require 'utils/stringHash'
fingerprint = require 'utils/fingerprint'
random = require 'utils/random'

module.exports = class ExperimentView extends View
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
            @instantiateSubViews("blocks", "BlockView")
            @preLoadExperiment()

    refreshTime: =>
        @time = @clock.getTime()

    startBlock: (block) =>
        blockView = @subViews[block.get("id")]
        if @blockView
            if @blockView.close then @blockView.close() else @blockView.remove()
        @blockdatamodel = @datamodel.get("blockdatahandlers").at(block) or
            @datamodel.get("blockdatahandlers").create()
        @datamodel.save()
        @blockView = blockView
        @blockView.datamodel = @blockdatamodel
        @blockView.render()
        @blockView.startBlock()

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
        currentBlock = @model.get("blocks").at(@datamodel.get("block") or 0)
        @startBlock currentBlock
