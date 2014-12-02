DropableView = require './DropableView'
Template = require '../templates/blockly'
ToolboxTemplate = require '../templates/blocklytoolbox'
BlocklyModelCodeTemplate = require '../templates/blocklymodelcode'

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
    Colour:
        [
            type: "colour_picker"
        ,
            type: "colour_random"
        ,
            type: "colour_rgb"
        ,
            type: "colour_blend"
        ]
    Text:
        [
            type: "text"
        ,
            type: "text_join"
        ,
            type: "text_create_join_container"
        ,
            type: "text_create_join_item"
        ,
            type: "text_append"
        ,
            type: "text_length"
        ,
            type: "text_isEmpty"
        ,
            type: "text_indexOf"
        ,
            type: "text_charAt"
        ,
            type: "text_getSubstring"
        ,
            type: "text_changeCase"
        ,
            type: "text_trim"
        ]
    Variables:
        custom: "VARIABLE"
    Functions:
        custom: "PROCEDURE"


module.exports = class BlocklyView extends DropableView
    template: Template
    toolboxTemplate: ToolboxTemplate
    defaultToolbox: toolbox

    initialize: ->
        super
        @toolbox = @defaultToolbox
        @registeredModels = []
        @registeredEvents = {}
        @registeredAttrs = {}
        @registeredMethods = {}

    render: ->
        super
        @listenToOnce @global_dispatcher, "blockly_loaded", @blocklyReady

    blocklyReady: (Blockly) =>
        @Blockly = Blockly
        @nameSpaceBlocklyVariables()
        @updateToolbox()
        @iframe$('body').on "dragleave", @dragLeave
        @iframe$('body').on "dragenter", @dragEnter
        @iframe$('body').on "drop", @drop
        @trigger "blockly_ready"

    iframe$: (selector) ->
        @$('iframe').contents().find(selector)

    drop: (event, ui) =>
        model = super(event, ui)
        @insertModelBlock(model)

    updateToolbox: ->
        @Blockly.updateToolbox(@toolboxTemplate(@toolbox))

    nameSpaceBlocklyVariables: ->
        variables_get = @Blockly.JavaScript['variables_get']
        variables_set = @Blockly.JavaScript['variables_set']
        @Blockly.JavaScript['variables_get'] = (block) ->
            [code, order] = variables_get block
            ["window.Variables.#{code}", order]
        @Blockly.JavaScript['variables_set'] = (block) ->
            code = variables_set block
            "window.Variables.#{code}"
    instantiateDropDown: (option) ->
        Blockly = @Blockly
        init: ->
            @setOutput(true, option.type)
            @appendDummyInput()
                .appendField(new Blockly.FieldDropdown(option.options),
                    'OPTIONS')
            @setColour 40

    codeGenDropDown: (option) ->
        Blockly = @Blockly
        (block) ->
            value = block.getFieldValue("OPTIONS")
            if option.type == 'String'
                value = "'#{value}'"
            [value, 0]

    addToToolbox: (type, category) =>
        toolbox_object = type: type
        if category not of @toolbox
            @toolbox[category] = []
        if not _.some(@toolbox, (x) -> x.type == type)
            @toolbox[category].push type: type

    insertModelBlocks: (model, category) =>
        if @registeredModels.length == 0
            eventType = @instantiateModelEventBlock()
            getType = @instantiateModelGetBlock()
            setType = @instantiateModelSetBlock()
            methodType = @instantiateModelMethodBlock()
            for type in [eventType, getType, setType, methodType]
                if type
                    @addToToolbox(type, category)
        @registeredModels.push [model.get("name"), model.get("name")]
        @registeredEvents[model.get("name")] =
            [trigger, trigger] for trigger in model.triggers()
        @registeredAttrs[model.get("name")] =
            [name, name] for name in model.allParameterNames()
        @registeredMethods[model.get("name")] =
            [method, method] for method in model.methods()
        @updateToolbox()


    instantiateModelEventBlock: () ->
        type = "PsychoCoffee_events"
        registeredModels = @registeredModels
        registeredEvents = @registeredEvents
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                events = registeredEvents[registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("when ")
                    .appendField(new Blockly.FieldDropdown(
                        -> registeredModels,
                        (option) ->
                            events = registeredEvents[option]
                            return undefined
                            ), "NAME")
                    .appendField(new Blockly.FieldDropdown(-> events),
                        "TRIGGERS")
                @appendStatementInput('DO').appendField('do')
        @Blockly.JavaScript[type] =
            (block) ->
                name = block.getFieldValue("NAME")
                event = block.getFieldValue("TRIGGERS")
                code = Blockly.JavaScript.statementToCode(block, 'DO')
                """this.listenTo(window.subViews['#{name}'],
                    '#{event}', function() {
                        #{code}
                        }"""
        return type

    instantiateModelGetBlock: () ->
        registeredModels = @registeredModels
        registeredAttrs = @registeredAttrs
        type = "PsychoCoffee_get"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                attrs = registeredAttrs[registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("get ")
                    .appendField(new Blockly.FieldDropdown(
                        -> registeredModels,
                        (option) ->
                            attrs = registeredAttrs[option]
                            return undefined
                            ), "NAME")
                    .appendField(new Blockly.FieldDropdown(
                        -> attrs), "ATTRS")
                @setOutput(true, null)
        @Blockly.JavaScript[type] =
            (block) ->
                name = block.getFieldValue("NAME")
                attr = block.getFieldValue("ATTRS")
                """window.subViews['#{name}'].get(
                    '#{attr}')"""
        return type

    instantiateModelSetBlock: () ->
        registeredModels = @registeredModels
        registeredAttrs = @registeredAttrs
        type = "PsychoCoffee_set"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                attrs = registeredAttrs[registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendValueInput("VALUE").appendField("set ")
                    .appendField(new Blockly.FieldDropdown(
                        -> registeredModels,
                        (option) ->
                            attrs = registeredAttrs[option]
                            return undefined
                            ), "NAME")
                    .appendField(new Blockly.FieldDropdown(
                        -> attrs), "ATTRS")
                @setPreviousStatement(true)
                @setNextStatement(true)
        @Blockly.JavaScript[type] =
            (block) ->
                name = block.getFieldValue("NAME")
                attr = block.getFieldValue("ATTRS")
                value = Blockly.JavaScript.valueToCode(block, "VALUE",
                    Blockly.JavaScript.ORDER_ATOMIC) || '0'
                """window.subViews['#{name}'].set(
                    '#{attr}', #{value})"""
        return type

    instantiateModelMethodBlock: () ->
        registeredModels = @registeredModels
        registeredMethods = @registeredMethods
        type = "PsychoCoffee_method"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                methods = registeredMethods[registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField(new Blockly.FieldDropdown(
                    -> methods), "METHODS").appendField(" ")
                    .appendField(new Blockly.FieldDropdown(
                        -> registeredModels,
                        (option) ->
                            methods = registeredMethods[option]
                            return undefined
                            ), "NAME")
                @setPreviousStatement(true)
                @setNextStatement(true)
        @Blockly.JavaScript[type] =
            (block) ->
                name = block.getFieldValue("NAME")
                method = block.getFieldValue("METHODS")
                "window.subViews['#{name}'].#{method}"
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
        @Blockly.JavaScript[type] =
            (block) ->
                attrs = {}
                attrs["name"] = model.get("name")
                attrs["parameters"] = []
                for option in model.requiredParameters().concat(
                    model.objectOptions())
                    paramobject = {}
                    if option.name == "name"
                        continue
                    paramobject["name"] = option.name
                    paramobject["value"] = Blockly.JavaScript.valueToCode(
                        block, option.name,
                        Blockly.JavaScript.ORDER_ATOMIC
                        ) or option.default or '0'
                    attrs["parameters"].push paramobject
                paramobject["last"] = true
                BlocklyModelCodeTemplate(attrs)
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
                    @Blockly.JavaScript[value_type] =
                        @codeGenDropDown(option)
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