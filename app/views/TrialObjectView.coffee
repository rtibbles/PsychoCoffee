'use strict'

View = require './View'

module.exports = class TrialObjectView extends View

    attach: (endpoints) ->
        return

    preLoadTrialObject: (queue) =>
        if @model.get("file")
            queue.loadFile(@model.get("file"))
            queue.on "fileload", @postFileLoad

    postFileLoad: (data) =>
        if data.item.src == @model.get("file")
            @object = data.result
            @render()

    render: =>
        @$el.html @object