module "TrialObject Model Tests",

    setup: =>
        window.trialObject = new PsychoCoffee.TrialObject.Model

test "Default values", ->
    expect 5

    equal window.trialObject.get("delay"), 0
    equal window.trialObject.get("duration"), 0
    equal window.trialObject.get("startWithTrial"), true
    deepEqual window.trialObject.get("parameterizedAttributes"), {}
    deepEqual window.trialObject.get("triggers"), []

test "Methods", ->
    expect 8
    
    trialProperties = window.trialObject.parameterizedTrial()
    equal trialProperties["delay"], 0
    equal trialProperties["duration"], 0
    equal trialProperties["startWithTrial"], true
    deepEqual trialProperties["parameterizedAttributes"], {}
    deepEqual trialProperties["triggers"], []

    deepEqual window.trialObject.returnRequired(), []
    ok window.trialObject.returnOptions() instanceof Object
    ok window.trialObject.allParameters() instanceof Object

test "Collection", ->

    expect 1

    collection = new PsychoCoffee.TrialObject.Collection

    model = collection.create()

    ok model instanceof PsychoCoffee.TrialObject.Model