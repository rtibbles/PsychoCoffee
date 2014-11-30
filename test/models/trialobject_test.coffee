module "TrialObject Model Tests",

    setup: ->
        @trialObject = new PsychoCoffee.TrialObject.Model

test "Default values", ->
    expect 5

    equal @trialObject.get("delay"), 0
    equal @trialObject.get("duration"), 0
    equal @trialObject.get("startWithTrial"), true
    deepEqual @trialObject.get("parameterizedAttributes"), {}
    deepEqual @trialObject.get("triggers"), []

test "Methods", ->
    expect 7
    
    trialProperties = @trialObject.parameterizedTrial()
    equal trialProperties["delay"], 0
    equal trialProperties["duration"], 0
    equal trialProperties["startWithTrial"], true
    deepEqual trialProperties["parameterizedAttributes"], {}

    deepEqual @trialObject.returnRequired(), {}
    ok @trialObject.returnOptions() instanceof Object
    ok @trialObject.allParameters() instanceof Object

test "Collection", ->

    expect 1

    collection = new PsychoCoffee.TrialObject.Collection

    model = collection.create()

    ok model instanceof PsychoCoffee.TrialObject.Model