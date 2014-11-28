DropableView = require './DropableView'
Template = require '../templates/blockly'

module.exports = class BlocklyView extends DropableView
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

    dragEnter: (event) =>
        super
        @$('iframe').animate({opacity: 0.5}, 'fast')

    dragLeave: (event) =>
        super
        @$('iframe').animate({opacity: 1}, 'fast')

    drop: (event) =>
        super
        @$('iframe').animate({opacity: 1}, 'fast')