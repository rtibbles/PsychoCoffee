'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class AudioTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @appendTo endpoints.hidden

    activate: ->
        if @object
            @object.play()
            super()

    deactivate: ->
        if @object
            @object.stop()
            super()

    render: =>
        if not @object
            @object = createjs.Sound.createInstance @model.getFile()
