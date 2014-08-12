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
        @logEvent("activated")

    deactivate: ->
        @object.unbind "keydown", @keyPressed
        @logEvent("deactivated")

    keyPressed: (event) =>
        if _.has(@keyCodeCache, event.keyCode)
            @trigger "keypress"
            @logEvent "keypress", key: @keyCodeCache[event.keyCode]

    render: ->
        return
