'use strict'

clock = require("utils/clock")
View = require './View'
Experiment = require '../models/Experiment'
ExperimentDataHandler = require '../models/ExperimentDataHandler'
Template = require 'templates/experiment'

module.exports = class ExperimentView extends View
    template: Template

    initialize: (options) =>
        super
        @model = new Experiment.Model(Experiment.Data[options.experiment])
        @clock = new clock.Clock()
        @refreshTime()
        @datacollection = new ExperimentDataHandler.Collection
        @datacollection.fetch().then =>
            @datamodel = @datacollection.getOrCreateParticipantModel(1)

    refreshTime: =>
        @time = @clock.getTime()

