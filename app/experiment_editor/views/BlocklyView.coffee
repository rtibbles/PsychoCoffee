View = require './View'
Template = require '../templates/blockly'

module.exports = class BlocklyView extends View
    template: Template

    render: ->
        super
        @listenToOnce @global_dispatcher, "blockly_loaded", @blocklyReady

    blocklyReady: (Blockly) =>
        @Blockly = Blockly

    iframe$: (selector) ->
        @iframe.contents().find(selector)