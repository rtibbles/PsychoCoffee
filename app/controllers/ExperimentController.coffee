'use strict'

clock = require("utils/clock")

module.exports = App.ExperimentController = Ember.ObjectController.extend
    init: ->
        @._super()
        @set 'clock', new clock.Clock()
        @refreshTime()
    refreshTime: ->
        @set 'time', @clock.getTime()