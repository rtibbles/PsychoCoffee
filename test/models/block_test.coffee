module "Block Model Tests",

    setup: =>
        window.block = new PsychoCoffee.Block.Model

test "Default values", ->
    expect 8

    ok window.block.get("trials") instanceof PsychoCoffee.Trial.Collection
    equal window.block.get("title"), ""
    equal window.block.get("width"), 640
    equal window.block.get("height"), 480
    equal window.block.get("timeout"), 1000
    equal window.block.get("numberOfTrials"), null
    ok window.block.get("parameterSet") instanceof PsychoCoffee.BlockParameterSet.Model
    ok window.block.get("trialObjects") instanceof PsychoCoffee.TrialObject.Collection

test "Methods", ->
    expect 9
    
    trialObject = window.block.createTrialObject()
    ok trialObject instanceof PsychoCoffee.TrialObject.Model
    [blockParameterSet, min_length, parameterObjectList] = window.block.returnParameters("testing", {})
    deepEqual blockParameterSet, {}
    equal min_length, 1
    deepEqual parameterObjectList, [{}]
    trialProperties = window.block.returnTrialProperties()
    equal trialProperties["title"], ""
    equal trialProperties["width"], 640
    equal trialProperties["height"], 480
    equal trialProperties["timeout"], 1000
    deepEqual trialProperties["triggers"], []