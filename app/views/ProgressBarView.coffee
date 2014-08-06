'use strict'

template = require '../templates/progressbar'
View = require './View'

module.exports = class ProgressBarView extends View
    id: 'progressBar'
    template: template

    initialize: (options) ->
        super
        @deferreds = options.deferreds
        @complete = options.complete
        @overallFraction = 0
        @progressCache = {}
        for model in @deferreds
            @bindProgressComplete(model)

    bindProgressComplete: (model) =>
        @listenTo model, "fileProgress", @progress

    progress: (data) ->
        oldFraction = @progressCache[data.model.id] or 0
        @progressCache[data.model.id] = data.fraction
        @overallFraction =
            @overallFraction + (data.fraction - oldFraction)/@deferreds.length
        @setProgressBar @overallFraction
        if data.fraction == 1 then @stopListening data.model
        if @overallFraction == 1
            @$el.animate(
                opacity: 0
            ,
                1000
            ,
                "swing"
            ,
                @close
                )

    close: =>
        @complete()
        @remove()

    setProgressBar: (fraction) ->
        progressBarWidth = fraction * @$el.find("#progressBar").width()
        @$el.find("#indicator").animate(
            width: progressBarWidth
        ,
            100
            ).html(
            Math.round(fraction * 100) + "%&nbsp;"
            )