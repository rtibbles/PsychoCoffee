module "BlockParameterSet Model Tests",

    setup: =>
        window.blockParameterSet = new PsychoCoffee.BlockParameterSet.Model

test "Default values", ->
    expect 3

    equal window.blockParameterSet.get("randomized"), false
    ok window.blockParameterSet.get("trialParameters") instanceof PsychoCoffee.Parameter.Collection
    ok window.blockParameterSet.get("blockParameters") instanceof PsychoCoffee.Parameter.Collection

test "Methods", ->
    expect 3
    
    [blockParameterSet, min_length, parameterObjectList] = window.blockParameterSet.returnTrialParameters("testing", null, {})
    deepEqual blockParameterSet, {}
    equal min_length, 1
    deepEqual parameterObjectList, [{}]
