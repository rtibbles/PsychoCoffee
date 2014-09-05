module "Experiment View Tests",

    setup: ->
        window.experimentview = new PsychoCoffee.ExperimentView

test "No Mock Default values", ->
    # Default values that do not require mocking
    expect 3

    ok window.experimentview.clock instanceof PsychoCoffee.clock.Clock, "Check clock instantiated"
    equal window.experimentview.user_id, PsychoCoffee.stringHash(PsychoCoffee.fingerprint()), "Check user_id instantiated"
    ok window.experimentview.datacollection instanceof PsychoCoffee.ExperimentDataHandler.Collection, "Check data collection instantiated"

test "No Mock Methods", ->
    # Methods that do not require mocking
    expect 1
    
    time = window.experimentview.time

    window.experimentview.refreshTime()

    notEqual time, window.experimentview.time

# TODO: Implement Sinon.js Mocking here to unit test Experiment View methods.

# test "Mock Default Values", ->
    # Default values that require mocking
    # ok window.experimentview.datamodel instanceof PsychoCoffee.ExperimentDataHandler.Model, "Check data model instantiated"