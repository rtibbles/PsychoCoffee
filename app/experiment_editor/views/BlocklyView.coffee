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
        @trigger "blockly_ready"

    iframe$: (selector) ->
        @$('iframe').contents().find(selector)

    drop: (event) =>
        model = super(event)
        @insertModelBlock(model)

    updateToolbox: ->
        @Blockly.updateToolbox(@toolboxTemplate(@toolbox))

    instantiateDropDown: (option) ->
        Blockly = @Blockly
        init: ->
            @setOutput(true, option.type)
            @appendDummyInput()
                .appendField(new Blockly.FieldDropdown(option.options),
                    'OPTIONS')
            @setColour 40

    insertModelBlocks: (model, category) =>
        eventType = @insertModelEventBlock(model)
        getType = @insertModelGetBlock(model)
        setType = @insertModelSetBlock(model)
        methodType = @insertModelMethodBlock(model)
        for type in [eventType, getType, setType, methodType]
            if type
                toolbox_object = type: type
                if category not of @toolbox
                    @toolbox[category] = []
                if not _.some(@toolbox, (x) -> x.type == type)
                    @toolbox[category].push type: type
        @updateToolbox()


    insertModelEventBlock: (model) ->
        if model.triggers().length == 0
            return false
        type = "PsychoCoffee_events_" + model.get("name")
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("when " + model.get("name"))
                    .appendField(new Blockly.FieldDropdown(
                        [trigger, trigger] for trigger in model.triggers()),
                        "TRIGGERS")
                @appendStatementInput('DO').appendField('do')
        return type

    insertModelGetBlock: (model) ->
        if model.allParameterNames().length == 0
            return false
        type = "PsychoCoffee_get_" + model.get("name")
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("get " + model.get("name"))
                    .appendField(new Blockly.FieldDropdown(
                        [name, name] for name in model.allParameterNames()),
                        "ATTRS")
                @setOutput(true, null)
        return type

    insertModelSetBlock: (model) ->
        if model.allParameterNames().length == 0
            return false
        type = "PsychoCoffee_set_" + model.get("name")
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendValueInput().appendField("set " + model.get("name"))
                    .appendField(new Blockly.FieldDropdown(
                        [name, name] for name in model.allParameterNames()),
                        "ATTRS")
                @setPreviousStatement(true)
                @setNextStatement(true)
        return type

    insertModelMethodBlock: (model) ->
        console.log model.methods()
        if model.methods().length == 0
            return false
        type = "PsychoCoffee_method_" + model.get("name")
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField(new Blockly.FieldDropdown(
                    [method, method] for method in model.methods()),
                        "METHODS").appendField(" " + model.get("name"))
                @setPreviousStatement(true)
                @setNextStatement(true)
        return type

    insertModelBlock: (model) ->
        type = "PsychoCoffee_" + model.get("name")
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @appendDummyInput().appendField(model.get("name"))
                for option in model.requiredParameters().concat(
                    model.objectOptions())
                    if option.name == "name"
                        continue
                    input = @appendValueInput(option.name)
                    input.appendField(option.name)
                    input.setCheck(option.type)
        parentBlock =
            @Blockly.Block.obtain @Blockly.getMainWorkspace(), type
        parentBlock.initSvg()
        parentBlock.render()
        for option in model.requiredParameters().concat(
            model.objectOptions())
            if option.name == "name" or not model.get(option.name)?
                continue
            if option.options
                value_type = option.name + "_drop_down"
                if value_type not of @Blockly.Blocks
                    @Blockly.Blocks[value_type] =
                        @instantiateDropDown(option)
                variable_type = "OPTIONS"
            else
                switch option.type
                    when "String"
                        value_type = "text"
                        variable_type = "TEXT"
                    when "Number"
                        value_type = "math_number"
                        variable_type = "NUM"
                    when "Boolean"
                        value_type = "logic_boolean"
                        variable_type = "BOOL"
                    when "Colour"
                        value_type = "colour_picker"
                        variable_type = "COLOUR"
                    else
                        value_type = "text"
                        variable_type = "TEXT"
            childBlock = @Blockly.Block.obtain @Blockly.getMainWorkspace(),
                value_type
            childBlock.setFieldValue(String(model.get(option.name)),
                variable_type)
            childBlock.initSvg()
            childBlock.render()
            parentBlock.getInput(option.name)
                .connection.connect(childBlock.outputConnection)