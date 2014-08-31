module "ExperimentParameterSet Model Tests",

    setup: =>
        window.experimentParameterSet = new PsychoCoffee.ExperimentParameterSet.Model

test "Default values", ->
    expect 2

    equal window.experimentParameterSet.get("randomized"), false
    ok window.experimentParameterSet.get("experimentParameters") instanceof PsychoCoffee.Parameter.Collection

test "Methods", ->
    expect 1
    
    experimentParameterSet = window.experimentParameterSet.returnExperimentParameters("testing")
    deepEqual experimentParameterSet, {}