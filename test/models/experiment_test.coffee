module "Experiment Model Tests",

    setup: ->
        @experiment = new PsychoCoffee.Experiment.Model

test "Default values", ->
    expect 4

    equal @experiment.get("name"), ""
    equal @experiment.get("saveInterval"), 10000
    ok @experiment.get("parameterSet") instanceof
        PsychoCoffee.ExperimentParameterSet.Model
    ok @experiment.get("blocks") instanceof PsychoCoffee.Block.Collection

test "Methods", ->
    expect 2
    
    block = @experiment.createBlock()
    ok block instanceof PsychoCoffee.Block.Model
    deepEqual @experiment.returnParameters("testing"), {}