'use strict'

TrialObjectView = require '../TrialObjectView'
Keys = require "utils/keys"

module.exports = class KeyboardTrialObjectView extends TrialObjectView

    initialize: =>
        super
        @keyCodeCache = _.invert(_.pick(Keys.Keys, @model.get("keys")))

    attach: (endpoints) ->
        @object = $(window)

    activate: =>
        @object.keydown @keyPressed
        super()

    deactivate: ->
        @object.unbind "keydown", @keyPressed
        super()

    keyPressed: (event) =>
        if _.has(@keyCodeCache, event.keyCode)
            key = @keyCodeCache[event.keyCode]
            @trigger "keypress", key: key, shiftKey: event.shiftKey
            @logEvent "keypress", key: key

    render: ->
        return
