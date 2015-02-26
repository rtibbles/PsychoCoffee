module "ExperimentParameterSet Model Tests",

    setup: ->
        @experimentParameterSet = new PsychoCoffee.ExperimentParameterSet.Model

test "Default values", ->
    expect 1

    ok @experimentParameterSet.get("experimentParameters") instanceof
        PsychoCoffee.Parameter.Collection

test "Methods", ->
    expect 1
    
    deepEqual @experimentParameterSet.returnExperimentParameters("testing"),
        {}