DropableView = require './DropableView'
Template = require '../templates/blockly'
ToolboxTemplate = require '../templates/blocklytoolbox'

toolbox =
    Logic:
        [
            type: "controls_if"
        ,
            type: "logic_compare"
        ,
            type: "logic_operation"
        ,
            type: "logic_negate"
        ,
            type: "logic_boolean"
        ,
            type: "logic_null"
        ,
            type: "logic_ternary"
        ]
    Loops:
        [
            type: "controls_repeat_ext"
        ,
            type: "controls_whileUntil"
        ,
            type: "controls_for"
        ,
            type: "controls_forEach"
        ,
            type: "controls_flow_statements"
        ]
    Math:
        [
            type: "math_number"
        ,
            type: "math_arithmetic"
        ,
            type: "math_single"
        ,
            type: "math_trig"
        ,
            type: "math_constant"
        ,
            type: "math_number_property"
        ,
            type: "math_change"
        ,
            type: "math_round"
        ,
            type: "math_on_list"
        ,
            type: "math_modulo"
        ,
            type: "math_constrain"
        ,
            type: "math_random_int"
        ,
            type: "math_random_float"
        ]
    Lists:
        [
            type: "lists_create_empty"
        ,
            type: "lists_create_with"
        ,
            type: "lists_repeat"
        ,
            type: "lists_length"
        ,
            type: "lists_isEmpty"
        ,
            type: "lists_indexOf"
        ,
            type: "lists_getIndex"
        ,
            type: "lists_setIndex"
        ]


module.exports = class BlocklyView extends DropableView
    template: Template
    toolboxTemplate: ToolboxTemplate
    defaultToolbox: toolbox

    initialize: ->
        super
        @toolbox = @defaultToolbox

    render: ->
        super
        @listenToOnce @global_dispatcher, "blockly_loaded", @blocklyReady

    blocklyReady: (Blockly) =>
        @Blockly = Blockly
        @updateToolbox()
        @iframe$('body').on "dragleave", @dragLeave
        @iframe$('body').on "dragenter", @dragEnter
        @iframe$('body').on "drop", @drop

    iframe$: (selector) ->
        @$('iframe').contents().find(selector)


    updateToolbox: ->
        @Blockly.updateToolbox(@toolboxTemplate(@toolbox))

    drop: (event) =>
        super
        @$('iframe').animate({opacity: 1}, 'fast')