module "Block Model Tests",

    setup: ->
        @block = new PsychoCoffee.Block.Model

test "Default values", ->
    expect 8

    ok @block.get("trials") instanceof PsychoCoffee.Trial.Collection
    equal @block.get("title"), ""
    equal @block.get("width"), 640
    equal @block.get("height"), 480
    equal @block.get("timeout"), 1000
    equal @block.get("numberOfTrials"), null
    ok @block.get("parameterSet") instanceof PsychoCoffee.BlockParameterSet.Model
    ok @block.get("trialObjects") instanceof PsychoCoffee.TrialObject.Collection

test "Methods", ->
    expect 9
    
    trialObject = @block.createTrialObject()
    ok trialObject instanceof PsychoCoffee.TrialObject.Model
    [blockParameterSet, min_length, parameterObjectList] = @block.returnParameters("testing", {})
    deepEqual blockParameterSet, {}
    equal min_length, 1
    deepEqual parameterObjectList, [{}]
    trialProperties = @block.returnTrialProperties()
    equal trialProperties["title"], ""
    equal trialProperties["width"], 640
    equal trialProperties["height"], 480
    equal trialProperties["timeout"], 1000
    deepEqual trialProperties["triggers"], []