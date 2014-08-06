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
            @instantiateSubViews("trials", "TrialView")
            @preLoadExperiment()

    refreshTime: =>
        @time = @clock.getTime()

    showTrial: (trial) =>
        trialView = @subViews[trial.get("id")]
        if @trialView
            if @trialView.close then @trialView.close() else @trialView.remove()
        @trialView = trialView
        @trialView.render()
        @trialView.appendTo("#trials")
        # @trialView.startTrial()

    preLoadExperiment: ->
        loadingModels = _.flatten(
            value.preLoadTrial() for key, value of @subViews)
        progressBarView = new ProgressBarView
            el: "#messages"
            deferreds: loadingModels
            complete: @startExperiment
        progressBarView.render()
        

    startExperiment: =>
        currentTrial = @model.get("trials").at(@datamodel.get("trial") or 0)
        @showTrial currentTrial
