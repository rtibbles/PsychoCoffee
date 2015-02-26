module "BlockParameterSet Model Tests",

    setup: ->
        @blockParameterSet = new PsychoCoffee.BlockParameterSet.Model

test "Default values", ->
    expect 2

    equal @blockParameterSet.get("randomized"), false
    ok @blockParameterSet.get("trialParameters") instanceof
        PsychoCoffee.Parameter.Collection

test "Methods", ->
    expect 2
    
    @blockParameterSet.setTrialParameters("testing", null, {})
    equal @blockParameterSet.get("min_length"), 1
    deepEqual @blockParameterSet.get("parameterObjectList"), [{}]
