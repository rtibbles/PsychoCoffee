'use strict'

clock = require("utils/clock")
View = require './View'
Experiment = require '../models/Experiment'
ExperimentDataHandler = require '../models/ExperimentDataHandler'
Template = require 'templates/experiment'
ProgressBarView = require './ProgressBarView'

module.exports = class ExperimentView extends View
    template: Template

    initialize: =>
        super
        @clock = new clock.Clock()
        @refreshTime()
        @render()
        @appendTo("#app")
        @datacollection = new ExperimentDataHandler.Collection
        @datacollection.fetch().then =>
            @datamodel = @datacollection.getOrCreateParticipantModel(1)
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
