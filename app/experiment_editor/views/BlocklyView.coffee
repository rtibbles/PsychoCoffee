View = require './View'
Template = require '../templates/blockly'

module.exports = class BlocklyView extends View
    template: Template

    render: ->
        super
        @listenToOnce @global_dispatcher, "blockly_loaded", @blocklyReady

    blocklyReady: (Blockly) =>
        @Blockly = Blockly
        @iframe$('body').on "dragleave", @dragLeave
        @iframe$('body').on "dragenter", @dragEnter
        @iframe$('body').on "drop", @drop

    iframe$: (selector) ->
        @$('iframe').contents().find(selector)

    dragEnter: (event) ->
        event.preventDefault()
        @$el.animate({opacity: 0.5}, 'fast')

    dragLeave: (event) ->
        event.preventDefault()
        @$('iframe').animate({opacity: 1}, 'fast')