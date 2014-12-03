module "Block Model Tests",

    setup: ->
        @block = new PsychoCoffee.Block.Model

test "Default values", ->
    expect 7

    equal @block.get("name"), ""
    equal @block.get("width"), 640
    equal @block.get("height"), 480
    equal @block.get("timeout"), 0
    equal @block.get("numberOfTrials"), null
    ok @block.get("parameterSet") instanceof
        PsychoCoffee.BlockParameterSet.Model
    ok @block.get("trialObjects") instanceof
        PsychoCoffee.TrialObject.Collection
