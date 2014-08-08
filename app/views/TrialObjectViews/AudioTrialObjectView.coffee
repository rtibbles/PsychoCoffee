'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class AudioTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        @appendTo endpoints.hidden

    preLoadTrialObject: (queue) =>
        queue.installPlugin createjs.Sound
        super

    activate: ->
        @object.play()

    deactivate: ->
        @object.stop()

    render: =>
        @object = createjs.Sound.createInstance @object_id
    # @object.on "succeeded", => console.log @clock.timerElapsed(), "playing"
    # @object.on "complete", => console.log @clock.timerElapsed(), "stopping"