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

class BlocklyValueView extends Backbone.View

    initialize: (options) ->
        @block = options.block
        @model = options.model
        @type = options.type
        @name = options.name
        @blocklyview = options.blocklyview
        @listenTo @model, "change:" + @name, @update

    update: =>
        @blocklyview.change_blocked = true
        @block.setFieldValue(String(@model.get(@name)),
            @type)

class BlocklyBlockView extends Backbone.View

    initialize: (options) ->
        @block = options.block
        @model = options.model
        @blocklyview = options.blocklyview
        @listenTo @blocklyview, "change", @update

    update: =>
        if not @block.workspace
            @model.destroy()
            @remove()

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
        @Blockly.addChangeListener @change
        @Blockly.registeredModels = []
        @Blockly.registeredEvents = {}
        @Blockly.registeredAttrs = {}
        @Blockly.registeredMethods = {}
        @nameSpaceBlocklyVariables()
        @instantiateFileDropDown()
        @updateToolbox()
        @iframe$('body').on "dragleave", @dragLeave
        @iframe$('body').on "dragenter", @dragEnter
        @iframe$('body').on "drop", @drop
        @trigger "blockly_ready"

    change: =>
        if not @change_blocked
            @trigger "change"
        else
            @change_blocked = false

    iframe$: (selector) ->
        @$('iframe').contents().find(selector)

    drop: (event, ui) =>
        model = super(event, ui)
        @insertModelBlock(model)

    generateCode: =>
        @Blockly.JavaScript.workspaceToCode()

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

    addClockBlocks: ->
        Blockly = @Blockly
        type_root = "PsychoCoffee_clock_"
        type = type_root + "trial_time"
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("time since trial start")
                @setOutput(true, "NUMBER")
        @Blockly.JavaScript[type] =
            (block) ->
                ["window.clock.getTime()", Blockly.JavaScript.ORDER_ATOMIC]
        @addToToolbox(type, "Data Logging")

        timers = {}
        type = type_root + "start_timer"
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("Start timer named ")
                    .appendField(new Blockly.FieldTextInput("timer", (text) ->
                        timers[@id] = text
                        ), "TIMER")
                @setPreviousStatement(true)
                @setNextStatement(true)
        @Blockly.JavaScript[type] =
            (block) ->
                timername = block.getFieldValue("TIMER")
                "window.clock.setTimer('#{timername}')"
        @addToToolbox(type, "Data Logging")

        type = type_root + "get_timer"
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("Timer count for ")
                    .appendField(new Blockly.FieldDropdown( ->
                        output = ([val, val] for key, val of timers)
                        if output.length == 0
                            output = [["",""]]
                        output
                        ), "TIMER")
                @setOutput(true, "NUMBER")
        @Blockly.JavaScript[type] =
            (block) ->
                timername = block.getFieldValue("TIMER")
                ["window.clock.getTimer('#{timername}')",
                    Blockly.JavaScript.ORDER_ATOMIC]
        @addToToolbox(type, "Data Logging")
        @updateToolbox()


    addDataModel: (dataModelName) ->
        Blockly = @Blockly
        type = "PsychoCoffee_dataHandler_#{dataModelName}"
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @setInputsInline true
                @appendValueInput("INPUT").appendField("Log ")
                @appendDummyInput().appendField(" as ")
                    .appendField(new Blockly.FieldTextInput("outputname"),
                        "PARAMETER")
                @setPreviousStatement(true)
                @setNextStatement(true)
        @Blockly.JavaScript[type] =
            (block) ->
                parameter = block.getFieldValue("PARAMETER")
                input = Blockly.JavaScript.valueToCode(block, "INPUT",
                    Blockly.JavaScript.ORDER_ATOMIC) || '0'
                "window.#{dataModelName}.set('#{parameter}', #{input})"
        @addToToolbox(type, "Data Logging")
        @updateToolbox()


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

    instantiateFileDropDown: ->
        Blockly = @Blockly
        Blockly.Blocks["file_dropdown"] =
            init: ->
                @setOutput(true, "File")
                @appendDummyInput()
                    .appendField(new Blockly.FieldDropdown(->
                        output = ([file.get("name"), file.get("name")]\
                            for file in PsychoEdit.files.models)
                        output =
                            if output.length > 0 then output else [["", ""]]
                        ),
                        'File')
                @setColour 40
        Blockly.JavaScript["file_dropdown"] =
            (block) ->
                value = block.getFieldValue("File")
                value = "'#{value}'"
                [value, 0]

    addToToolbox: (type, category) =>
        toolbox_object = type: type
        if category not of @toolbox
            @toolbox[category] = []
        if not _.some(@toolbox, (x) -> x.type == type)
            @toolbox[category].push type: type

    insertModelBlocks: (collection, category) =>
        @collection = collection
        @category = category
        if @collection.length > 0
            @createModelBlocks()
        else
            @listenToOnce @collection, "add", @createModelBlocks

    createModelBlocks: =>
        @registerModels()
        eventType = @instantiateModelEventBlock()
        getType = @instantiateModelGetBlock()
        setType = @instantiateModelSetBlock()
        methodType = @instantiateModelMethodBlock()
        for type in [eventType, getType, setType, methodType]
            if type
                @addToToolbox(type, @category)
        @updateToolbox()
        @listenTo @collection, "add", @registerModels
        @listenTo @collection, "remove", @registerModels
        @listenTo @collection, "change", @registerModels


    registerModels: =>
        @Blockly.registeredModels = _.map @collection.models, (model) ->
            [model.get("name"), model.get("name")]
        @Blockly.registeredEvents = _.object(
            ([model.get("name"), [trig, trig]\
                for trig in model.triggers()] for model in @collection.models))
        @Blockly.registeredAttrs = _.object(
            ([model.get("name"), [name, name]\
                for name in model.allParameterNames()]\
                    for model in @collection.models))
        @Blockly.registeredMethods = _.object(
            ([model.get("name"), [method, method]\
                for method in model.methods()]\
                    for model in @collection.models))
        @updateToolbox()

    instantiateModelEventBlock: ->
        type = "PsychoCoffee_events"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                events =
                    Blockly.registeredEvents[Blockly.registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("when ")
                    .appendField(new Blockly.FieldDropdown(
                        -> Blockly.registeredModels,
                        (option) ->
                            events = Blockly.registeredEvents[option]
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
                """window.trialView.listenTo(window.subViews['#{name}'],
                    '#{event}', function() {
                        #{code}
                        })"""
        return type

    instantiateModelGetBlock: ->
        type = "PsychoCoffee_get"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                attrs =
                    Blockly.registeredAttrs[Blockly.registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField("get ")
                    .appendField(new Blockly.FieldDropdown(
                        -> Blockly.registeredModels,
                        (option) ->
                            attrs = Blockly.registeredAttrs[option]
                            return undefined
                            ), "NAME")
                    .appendField(new Blockly.FieldDropdown(
                        -> attrs), "ATTRS")
                @setOutput(true, null)
        @Blockly.JavaScript[type] =
            (block) ->
                name = block.getFieldValue("NAME")
                attr = block.getFieldValue("ATTRS")
                """window.subViews['#{name}'].model.get(
                    '#{attr}')"""
        return type

    instantiateModelSetBlock: ->
        type = "PsychoCoffee_set"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                attrs =
                    Blockly.registeredAttrs[Blockly.registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendValueInput("VALUE").appendField("set ")
                    .appendField(new Blockly.FieldDropdown(
                        -> Blockly.registeredModels,
                        (option) ->
                            attrs = Blockly.registeredAttrs[option]
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
                """window.subViews['#{name}'].model.set(
                    '#{attr}', #{value})"""
        return type

    instantiateModelMethodBlock: ->
        type = "PsychoCoffee_method"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                methods =
                    Blockly.registeredMethods[Blockly.registeredModels[0][0]]
                @setColour 40
                @setInputsInline true
                @appendDummyInput().appendField(new Blockly.FieldDropdown(
                    -> methods), "METHODS").appendField(" ")
                    .appendField(new Blockly.FieldDropdown(
                        -> Blockly.registeredModels,
                        (option) ->
                            methods = Blockly.registeredMethods[option]
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

    insertModelBlock: (model, y) ->
        type = "PsychoCoffee_" + model.get("name")
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @appendDummyInput().appendField(model.get("name"))
                @appendDummyInput().appendField(model.get("type"))
                    .setAlign(Blockly.ALIGN_RIGHT)
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
        parentBlock.subViews = {}
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
                value = String(model.get(option.name))
            else
                value = String(model.get(option.name))
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
                        value = value.toUpperCase()
                    when "Colour"
                        value_type = "colour_picker"
                        variable_type = "COLOUR"
                    when "File"
                        value_type = "file_dropdown"
                        variable_type = "File"
                    else
                        value_type = "text"
                        variable_type = "TEXT"
            childBlock = @Blockly.Block.obtain @Blockly.getMainWorkspace(),
                value_type
            childBlock.attr_name = option.name
            childBlock.setFieldValue(value, variable_type)
            childBlock.initSvg()
            childBlock.render()
            parentBlock.getInput(option.name)
                .connection.connect(childBlock.outputConnection)
            parentBlock.subViews[option.name] = new BlocklyValueView({
                block: childBlock
                model: model
                type: variable_type
                name: option.name
                blocklyview: @
            })
        parentBlock.setCollapsed(true)
        if y then parentBlock.moveBy(0, y*40)
        parentBlock.subViews["self"] = new BlocklyBlockView({
            block: parentBlock
            model: model
            blocklyview: @
        })