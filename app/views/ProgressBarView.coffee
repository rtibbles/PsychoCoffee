'use strict'

template = require '../templates/progressbar'
View = require './View'

module.exports = class ProgressBarView extends View
    id: 'progressBar'
    template: template

    initialize: (options) =>
        super
        @queue = options.queue
        @complete = options.complete
        @queue.on "progress", @progress
        @queue.on "complete", @finish

    progress: (data) =>
        @setProgressBar data.progress

    finish: =>
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