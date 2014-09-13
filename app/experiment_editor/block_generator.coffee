'use strict'

import_TrialObjects = ->

    for key, val of PsychoCoffee.trialObjectTypeKeys
        model = PsychoCoffee[val].Model
        colour = PsychoCoffee[val].Colour or 40
        Blockly.Blocks["PsychoCoffee_" + key] =
            init: ->
                @setColour colour
                @appendDummyInput().appendField(key)
                for option in model.prototype.requiredParameters().concat(
                    model.prototype.objectOptions())
                    input = @appendValueInput(option.name)
                    input.setCheck(option.type)
                    input.appendField(option.name)
                    if option.options
                        dropdown = new Blockly.FieldDropdown(option.options)
                        input.appendField(dropdown, option.name)
                    else
                        if option.type == "String"
                            textInput = new Blockly.FieldTextInput(
                                option.default)
                            input.appendField(textInput, option.name)
                        if option.type == "Colour"
                            colour = new Blockly.FieldColour(option.default)
                            input.appendField(colour, option.name)


$ ->
    import_TrialObjects()