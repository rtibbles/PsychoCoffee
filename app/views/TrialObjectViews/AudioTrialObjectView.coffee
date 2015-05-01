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
            @object = createjs.Sound.createInstance @file_path
            @setEventListeners()

    setEventListeners: =>
        @proxyObjectEvents ["complete"]
        @listenTo @, "complete", @deactivate

    removeEventListeners: =>
        if @object
            @object.removeAllEventListeners()

    close: =>
        super
        if @object
            try
                @object.destroy()
            catch
                delete @object

    pause: =>
        @object.pause()

    resume: =>
        @object.resume()