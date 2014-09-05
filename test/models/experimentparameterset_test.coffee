module "ExperimentParameterSet Model Tests",

    setup: ->
        @experimentParameterSet = new PsychoCoffee.ExperimentParameterSet.Model

test "Default values", ->
    expect 2

    equal @experimentParameterSet.get("randomized"), false
    ok @experimentParameterSet.get("experimentParameters") instanceof PsychoCoffee.Parameter.Collection

test "Methods", ->
    expect 1
    
    experimentParameterSet = @experimentParameterSet.returnExperimentParameters("testing")
    deepEqual experimentParameterSet, {}