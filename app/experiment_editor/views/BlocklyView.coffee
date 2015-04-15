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

valueToModelConverter =
    TEXT: String
    NUM: Number
    BOOL: Boolean
    COLOUR: String
    File: String


class BlocklyValueView extends Backbone.View

    initialize: (options) ->
        @parentBlock = options.parentBlock
        @model = options.model
        @blocklyview = options.blocklyview
        @Blockly = @blocklyview.Blockly
        @option = options.option
        @name = @option?.name or options.name
        if @model.has("__Blockly_" + @name)
            @listenToOnce @blocklyview, "insertXml", => @createBlock(options)
            options.connect = true
        else
            options.connect = !options.block?
            @createBlock(options)

    createBlock: (options) =>
        if @model.has("__Blockly_" + @name)
            xml = @Blockly.Xml.textToDom "<xml>" +
                @model.get("__Blockly_" + @name) + "</xml>"
            xml = xml.childNodes[0]
            options.block =
                @Blockly.Xml.domToBlock @Blockly.getMainWorkspace(), xml
        if @option?.options
            @value_type = @option.name + "_drop_down"
            if @value_type not of @Blockly.Blocks
                @Blockly.Blocks[@value_type] =
                    @instantiateDropDown(@option)
                @Blockly.JavaScript[@value_type] =
                    @codeGenDropDown(@option)
            @variable_type = "OPTIONS"
            @value = String(@model.get(@option.name))
        else
            if @option
                @value = String(@model.get(@option.name))
                type = @option.type
            else
                @value = options.value
                type = options.type
            switch type
                when "String"
                    @value_type = "text"
                    @variable_type = "TEXT"
                when "Number"
                    @value_type = "math_number"
                    @variable_type = "NUM"
                when "Boolean"
                    @value_type = "logic_boolean"
                    @variable_type = "BOOL"
                    @value = @value.toUpperCase()
                when "Colour"
                    @value_type = "colour_picker"
                    @variable_type = "COLOUR"
                when "File"
                    @value_type = "file_dropdown"
                    @variable_type = "File"
                else
                    @value_type = "text"
                    @variable_type = "TEXT"
        if options.block?
            @block = options.block
            @updateModelField(false)
        else
            @block = @Blockly.Block.obtain(
                @Blockly.getMainWorkspace(), @value_type
                )
            @block.attr_name = @name
            @block.setFieldValue(@value, @variable_type)
            @block.initSvg()
            @block.render()
        if @parentBlock? and options.connect
            @parentBlock.setCollapsed(false)
            @parentBlock.getInput(@name)
                .connection.connect(@block.outputConnection)
            @parentBlock.setCollapsed(true)
        @block.ignoreForXml = true
        @block.view = @
        @listenTo @model, "change:" + @name, @update
        @Blockly.addChangeListener @updateBlock

    bindModel: =>
        input = _.find @block.parentBlock_.inputList, (x) =>
            x.connection == @block.outputConnection.targetConnection
        @model = @block.parentBlock_.view.model
        @name = input.name
        @listenTo @model, "change:" + @name, @update

    unbindModel: =>
        @stopListening @model
        delete @block.ignoreForXml
        delete @model
        delete @name

    update: =>
        if not @setting
            if @block.getFieldValue(@variable_type)?
                value = String(@model.get(@name))
                if @variable_type == "BOOL"
                    value = value.toUpperCase()
                if value != @block.getFieldValue(@variable_type)
                    @block.setFieldValue(value, @variable_type)
        else
            @setting = false

    updateBlock: (event) =>
        if not @block?
            @remove()
        else if @model?
            if not @block.parentBlock_?
                @unbindModel()
            else
                parentSvg = @block.parentBlock_.getSvgRoot()
                if _.last(event.srcElement.childNodes) == parentSvg
                    @updateModelField()
        else if @block.parentBlock_?
            @bindModel()

    updateModelField: (setting=true) =>
        if @block.getFieldValue(@variable_type)?
            value = @block.getFieldValue(@variable_type)
            if @variable_type == "BOOL"
                value = value.toLowerCase()
            value = valueToModelConverter[@variable_type](value)
            if @model.get(@name) != value
                @setting = setting
                @model.set(@name, value)
        else
            timer = _.some @block.getDescendants(), (x) ->
                x.type.search("PsychoCoffee_clock_get") == 0 or
                x.type.search("PsychoCoffee_clock_trial_time") == 0
            variables = _.filter @block.getDescendants(), (x) ->
                x.type.search("variables_get") == 0
            trialObjects = _.filter @block.getDescendants(), (x) ->
                x.type.search("PsychoCoffee_get") == 0
            if _.some(trialObjects, (x) =>
                (@name == x.getFieldValue("ATTRS") and
                @model.get("name") == x.getFieldValue("NAME"))
                )
                alert """
                    You have included a self reference in this property.
                    Please change it and don't do it again.
                    """
                return
            variables = variables.map (x) ->
                modelPath: ["Variables"]
                trigger : "change:" + x.getFieldValue("VAR")
            trialObjects = trialObjects.map (x) ->
                modelPath: ["trialObjects", x.getFieldValue("NAME")]
                trigger : "change:" + x.getFieldValue("ATTRS")
            listeners = variables.concat trialObjects
            if timer
                listeners.push
                    modelPath: "clock"
                    trigger: "tick"
            code = @Blockly.JavaScript.blockToCode @block
            code = "return " + code[0]
            blockXml = @Blockly.Xml.blockToDom_ @block
            blockXmlText = @Blockly.Xml.domToText blockXml
            @model.set "__Blockly_" + @name, blockXmlText
            @model.setFunction @name, Function(code), listeners: listeners



class BlocklyBlockView extends Backbone.View

    initialize: (options) ->
        @type = options.type
        @model = options.model
        @blocklyview = options.blocklyview
        @Blockly = @blocklyview.Blockly
        @y = options.y
        @block = @Blockly.Block.obtain(
            @Blockly.getMainWorkspace(), @type)
        @block.initSvg()
        @block.render()
        @block.subViews = {}
        for option in @model.requiredParameters().concat(
            @model.objectOptions())
            if option.name == "name" or not @model.get(option.name)?
                continue
            @createSubView(option)
        @block.setCollapsed(true)
        @block.ignoreForXml = true
        @block.view = @
        if @y then @block.moveBy(0, @y*40)
        @listenTo @blocklyview, "change", @update
        @Blockly.addChangeListener @updateModel

    createSubView: (option, name, block) =>
        @block.subViews[option?.name or name] = new BlocklyValueView
            option: option
            name: name
            block: block
            model: @model
            blocklyview: @blocklyview
            parentBlock: @block

    update: =>
        if not @block.workspace
            @model.destroy()
            @remove()

    updateModel: (event) =>
        if _.last(event.srcElement.childNodes) == @block.getSvgRoot()
            if @model.get("name") != @block.getFieldValue("name")
                @model.set "name", @block.getFieldValue("name")
            for input in @block.inputList
                block = input.connection?.targetConnection?.sourceBlock_
                if block
                    if not block.view?
                        @createSubView undefined, input.name, block

module.exports = class BlocklyView extends DropableView
    template: Template
    toolboxTemplate: ToolboxTemplate
    defaultToolbox: toolbox

    initialize: ->
        super
        @toolbox = @defaultToolbox
        @subViews = {}

    render: ->
        super
        @listenToOnce @global_dispatcher, "blockly_loaded", @blocklyReady

    blocklyReady: (Blockly) =>
        @Blockly = Blockly
        @Blockly.registeredModels = []
        @Blockly.registeredEvents = {}
        @Blockly.registeredAttrs = {}
        @Blockly.registeredMethods = {}
        @nameSpaceBlocklyVariables()
        @instantiateFileDropDown()
        @insertEndBlocks()
        @updateToolbox()
        @iframe$('body').on "dragleave", @dragLeave
        @iframe$('body').on "dragenter", @dragEnter
        @iframe$('body').on "drop", @drop
        @trigger "blockly_ready"

    change: =>
        xmlText = '<xml xmlns="http://www.w3.org/1999/xhtml">'
        for block in @Blockly.mainWorkspace.getTopBlocks()
            if not block.ignoreForXml
                blockXml = @Blockly.Xml.blockToDom_ block
                blockXmlText = @Blockly.Xml.domToText blockXml
                xmlText = xmlText += blockXmlText
        xmlText += '</xml>'
        @model.set "blocklyCode", xmlText
        @checkVariables()
        @trigger "change"

    checkVariables: =>
        registeredVariables = @getAllVariableNames()
        for variable in @Blockly.Variables.allVariables()
            if variable not in registeredVariables
                @model.get("parameterSet").get("trialParameters").create
                    name: variable

    iframe$: (selector) ->
        @$('iframe').contents().find(selector)

    drop: (event, ui) =>
        model = super(event, ui)
        if model.has("file_id")
            @insertFileObject(model)
        else
            @insertModelBlock(model)

    generateCode: =>
        @Blockly.JavaScript.workspaceToCode()

    updateToolbox: =>
        @Blockly.updateToolbox(@toolboxTemplate(@toolbox))

    getAllVariableNames: =>
        _.map(@model.get("parameterSet").get("trialParameters").models
            .concat(@model.collection.parents[0].get("parameterSet")
                .get("experimentParameters").models), (x) -> x.get("name"))

    nameSpaceBlocklyVariables: =>
        variable_names = @getAllVariableNames()
        Blockly = @Blockly
        @Blockly.JavaScript['variables_get'] = (block) ->
            code = Blockly.JavaScript.variableDB_.getName(
                block.getFieldValue('VAR'),
                Blockly.Variables.NAME_TYPE)
            ["window.Variables.get('#{code}')",
            Blockly.JavaScript.ORDER_ATOMIC]
        @Blockly.JavaScript['variables_set'] = (block) ->
            argument0 = Blockly.JavaScript.valueToCode(block, 'VALUE',
                Blockly.JavaScript.ORDER_ASSIGNMENT) or '0'
            varName = Blockly.JavaScript.variableDB_.getName(
                block.getFieldValue('VAR'), Blockly.Variables.NAME_TYPE)
            "window.Variables.set('#{varName}', #{argument0})"
        for name in variable_names
            block = @Blockly.Block.obtain(
                @Blockly.getMainWorkspace(), "variables_get")
            block.setFieldValue(name, "VAR")
            block.initSvg()
            block.render()
            block.setEditable(false)
            block.setMovable(false)
            block.setDisabled(true)
            block.moveBy(-500, -500)
            block.ignoreForXml = true

    addClockBlocks: =>
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


    addDataModel: (dataModelName) =>
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


    instantiateDropDown: (option) =>
        Blockly = @Blockly
        init: ->
            @setOutput(true, option.type)
            @appendDummyInput()
                .appendField(new Blockly.FieldDropdown(option.options),
                    'OPTIONS')
            @setColour 40

    codeGenDropDown: (option) =>
        Blockly = @Blockly
        (block) ->
            value = block.getFieldValue("OPTIONS")
            if option.type == 'String'
                value = "'#{value}'"
            [value, 0]

    instantiateFileDropDown: =>
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

    insertBlocklyXML: =>
        @trigger "insertXml"
        if @model.get("blocklyCode")?
            xml = @Blockly.Xml.textToDom @model.get("blocklyCode")
            @Blockly.Xml.domToWorkspace @Blockly.mainWorkspace, xml
        @Blockly.addChangeListener @change

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

    instantiateModelEventBlock: =>
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
                "window.trialView.listenTo(window.subViews['#{name}'],\
                    '#{event}', function() {\
                        #{code}\
                        })"
        return type

    instantiateModelGetBlock: =>
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
                ["window.trialObjects['#{name}'].get('#{attr}')",
                    Blockly.JavaScript.ORDER_ATOMIC]
        return type

    instantiateModelSetBlock: =>
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
                "window.trialObjects['#{name}'].set(\
                    '#{attr}', #{value})"
        return type

    instantiateModelMethodBlock: =>
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

    insertModelBlock: (model, y) =>
        type = "PsychoCoffee_" + model.get("name")
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                @appendDummyInput().appendField(
                    new Blockly.FieldTextInput(model.get("name"), (name) ->
                        modelnames =
                            (item[0] for item in Blockly.registeredModels)
                        if name != model.get("name") and name in modelnames
                            model.get("name")
                        else
                            name
                        ), "name")
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
        @subViews[type] = new BlocklyBlockView({
            type: type
            model: model
            blocklyview: @
            y: y
        })

    insertFileObject: (model) =>
        new BlocklyValueView({
            value: model.get("name")
            type: "File"
            model: model
            blocklyview: @
        })

    insertEndBlocks: =>
        endblocks = ["Trial", "Block", "Experiment"]
        endblockdropdown = endblocks.map((item) -> [item, item])
        type = "PsychoCoffee_end"
        Blockly = @Blockly
        @Blockly.Blocks[type] =
            init: ->
                @setColour 40
                modedropdown = new Blockly.FieldDropdown(endblockdropdown)
                @setPreviousStatement(true)
                @appendDummyInput().appendField("End #{name}")
                    .appendField(modedropdown, 'MODE')
        @Blockly.JavaScript[type] =
            (block) ->
                name = block.getFieldValue('MODE')
                "window.#{name.toLowerCase()}View.end#{name}()"
        @addToToolbox(type, "Flow Statements")
