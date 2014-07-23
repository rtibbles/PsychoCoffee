'use strict'

clock = require("utils/clock")
View = require './View'
ExperimentDataHandler = require '../models/ExperimentDataHandler'
Template = require 'templates/experiment'

module.exports = class ExperimentView extends View
    template: Template

    initialize: =>
        super
        @clock = new clock.Clock()
        @refreshTime()
        @datacollection = new ExperimentDataHandler.Collection
        @datacollection.fetch()
        @datamodel = @datacollection.getOrCreateParticipantModel(1)

    refreshTime: =>
        @time = @clock.getTime()

