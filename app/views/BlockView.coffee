'use strict'

View = require './View'

module.exports = class BlockView extends View

    initialize: (options) =>
        super
        @generateTrialModels()
        @instantiateSubViews("trials",
            "TrialView", @trialObjectViewType)

    generateTrialModels: ->
        [trialListLength, parameterSet] = @model.returnParameters()
        if not trialListLength
            @model.get("trials").create @model.returnTrialProperties(true)
        else
            for parameters in parameterSet
                trial =
                    @model.get("trials").create @model.returnTrialProperties()
                trial.get("trialObjects").add(
                    (model.parameterizedTrial(parameters) \
                    for model in @model.get("trialObjects").models)
                    )

    preLoadBlock: (queue) =>
        for key, view of @subViews
            view.preLoadTrial(queue)

    startBlock: ->
        @datamodel.set("trial", @datamodel.get("trial") or 0)
        currentTrial = @model.get("trials").at(@datamodel.get("trial"))
        @showTrial currentTrial

    showTrial: (trial) =>
        if not trial
            console.log "Done, finito, finished!"
            return
        trialView = @subViews[trial.get("id")]
        if @trialView
            if @trialView.close then @trialView.close() else @trialView.remove()
        @trialdatamodel =
            @datamodel.get("trialdatalogs").at(@datamodel.get("trial")) or
            @datamodel.get("trialdatalogs").create()
        @datamodel.save()
        @trialView = trialView
        @trialView.datamodel = @trialdatamodel
        @trialView.render()
        @trialView.appendTo("#trials")
        @listenToOnce @trialView, "trialEnded", @nextTrial
        @trialView.startTrial()

    nextTrial: ->
        @datamodel.set("trial", @datamodel.get("trial") + 1)
        currentTrial = @model.get("trials").at(@datamodel.get("trial"))
        @showTrial currentTrial