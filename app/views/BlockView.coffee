'use strict'

HandlerView = require './HandlerView'

module.exports = class BlockView extends HandlerView

    initialize: (options) =>
        super
        @model.setParameters(@user_id, @injectedParameters)
        @instantiateSubView(@model,
            "TrialView", "trialView", editor: @editor)
        # trialSelector is a function that takes two arguments:
        # the list of possible trials, and the trial number.
        @trialSelector = options.selector or @defaultNextTrial

    preLoadBlock: (queue) =>
        for key, view of @subViews
            view.preLoadTrial(queue)

    previewBlock: =>
        window.trialView = @trialView = @subViews["trialView"]
        @trialdatamodel =
            @datamodel.get("trialdatalogs").add({})
        @trialView.datamodel = @trialdatamodel
        @trialView.render()
        @trialView.appendTo("#trials")
        @trialView.editor = true
        @trialView

    startBlock: ->
        date_time = new Date().getTime()
        if @datamodel.get("start_time")?
            @logEvent "block_resume", date_time: date_time
        else
            @datamodel.set "start_time", date_time
            @logEvent "block_start", date_time: date_time
        @datamodel.set "block_id", @model.id
        @datamodel.set "parameters", @parameters
        window.Variables = _.extend(window.Variables, @parameters)
        @datamodel.set("trial", @datamodel.get("trial") or 0)
        @model.setTrialParameters @datamodel.get("trial")
        if @model.get "trialParameters" then @showTrial() else @endBlock()

    showTrial: =>
        window.trialView = @trialView = @subViews["trialView"]
        @trialdatamodel =
            @datamodel.get("trialdatalogs").at(@datamodel.get("trial")) or
            @datamodel.get("trialdatalogs").create()
        @datamodel.save()
        @trialView.datamodel = @trialdatamodel
        @trialView.render()
        @trialView.appendTo("#trials")
        @listenToOnce @trialView, "trialEnded", @nextTrial
        @trialView.startTrial()

    defaultNextTrial: (trials, trialnumber) ->
        trialnumber + 1

    nextTrial: ->
        @datamodel.set("trial",
            @trialSelector(@model.get("trials"), @datamodel.get("trial")))
        @model.setTrialParameters @datamodel.get("trial")
        if @model.get "trialParameters" then @showTrial else @endBlock()

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