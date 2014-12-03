module "BlockParameterSet Model Tests",

    setup: ->
        @blockParameterSet = new PsychoCoffee.BlockParameterSet.Model

test "Default values", ->
    expect 3

    equal @blockParameterSet.get("randomized"), false
    ok @blockParameterSet.get("trialParameters") instanceof
        PsychoCoffee.Parameter.Collection
    ok @blockParameterSet.get("blockParameters") instanceof
        PsychoCoffee.Parameter.Collection

test "Methods", ->
    expect 3
    
    @blockParameterSet.setTrialParameters("testing", null, {})
    deepEqual @blockParameterSet.get("blockParameterSet"), {}
    equal @blockParameterSet.get("min_length"), 1
    deepEqual @blockParameterSet.get("parameterObjectList"), [{}]
