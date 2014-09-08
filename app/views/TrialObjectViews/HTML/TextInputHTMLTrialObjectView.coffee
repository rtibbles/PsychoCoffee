'use strict'

HTMLTrialObjectView = require '../HTMLTrialObjectView'
Template = require "/templates/TrialObjects/HTML/textinput"

module.exports = class TextInputHTMLTrialObjectView extends HTMLTrialObjectView

    template: Template

    deactivate: ->
        super
        @logInput()

    logInput: ->
        @logEvent "text_input", "text_value": @$(".text-input").val()