'use strict'

View = require './View'

module.exports = class BlockView extends View

    initialize: (options) =>
        super
        @generateTrialModels()
        @instantiateSubViews("trials",
            "TrialView", @trialObjectViewType)

    generateTrialModels: ->
        [trialListLength, parameters] = @model.returnParameters()
        if not trialListLength
            @model.get("trials").create @model.returnTrialProperties()

    preLoadBlock: (queue) =>
        for key, view of @subViews
            view.preLoadTrial(queue)

    startBlock: ->
        currentTrial = @model.get("trials").at(@datamodel.get("trial") or 0)
        @showTrial currentTrial

    showTrial: (trial) =>
        trialView = @subViews[trial.get("id")]
        if @trialView
            if @trialView.close then @trialView.close() else @trialView.remove()
        @trialView = trialView
        @trialView.render()
        @trialView.appendTo("#trials")
        @trialView.startTrial()