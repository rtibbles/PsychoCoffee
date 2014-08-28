'use strict'

HandlerView = require './HandlerView'

module.exports = class BlockView extends HandlerView

    initialize: (options) =>
        super
        @generateTrialModels()
        @instantiateSubViews("trials",
            "TrialView", null)

    generateTrialModels: ->
        [@parameters, @trialListLength, @parameterSet] =
            @model.returnParameters(@user_id, @injectedParameters)
        for parameters in @parameterSet
            trial =
                @model.get("trials").create @model.returnTrialProperties(
                    parameters)
            trial.set "parameters", parameters
            trial.get("trialObjects").add(
                (model.parameterizedTrial(parameters) \
                for model in @model.get("trialObjects").models)
                )

    preLoadBlock: (queue) =>
        for key, view of @subViews
            view.preLoadTrial(queue)

    startBlock: ->
        date_time = new Date().getTime()
        if @datamodel.get("start_time")?
            @logEvent "block_resume", date_time: date_time
        else
            @datamodel.set "start_time", date_time
            @logEvent "block_start", date_time: date_time
        @datamodel.set "block_id", @model.id
        @datamodel.set "parameters", @parameters
        @datamodel.set("trial", @datamodel.get("trial") or 0)
        currentTrial = @model.get("trials").at(@datamodel.get("trial"))
        @showTrial currentTrial

    showTrial: (trial) =>
        if not trial
            @endBlock()
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

    endBlock: ->
        date_time = new Date().getTime()
        @logEvent "block_end", date_time: date_time
        @datamodel.set "end_time", date_time
        @datamodel.set "complete", true
        for key, view of @subViews
            view.remove()
        @stopListening()
        @remove()
        @trigger "blockEnded"