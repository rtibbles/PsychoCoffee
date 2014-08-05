'use strict'

View = require './View'
Template = require 'templates/trial'

module.exports = class TrialView extends View
    template: Template

    initialize: =>
        super
        @instantiateSubViews("trialObjects", "TrialObjectView")


