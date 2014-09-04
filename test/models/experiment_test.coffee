module "Experiment Model Tests",

    setup: ->
        window.experiment = new PsychoCoffee.Experiment.Model

test "Default values", ->
    expect 4

    equal window.experiment.get("title"), "Experiment"
    equal window.experiment.get("saveInterval"), 10000
    ok window.experiment.get("parameterSet") instanceof PsychoCoffee.ExperimentParameterSet.Model
    ok window.experiment.get("blocks") instanceof PsychoCoffee.Block.Collection

test "Initialize", ->
    expect 1
    ok PsychoCoffee.random.GUIDseed?

test "Methods", ->
    expect 2
    
    block = window.experiment.createBlock()
    ok block instanceof PsychoCoffee.Block.Model
    deepEqual window.experiment.returnParameters("testing"), {}