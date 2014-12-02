module "TrialObject Model Tests",

    setup: ->
        @trialObject = new PsychoCoffee.TrialObject.Model

test "Default values", ->
    expect 3

    equal @trialObject.get("delay"), 0
    equal @trialObject.get("duration"), 0
    equal @trialObject.get("startWithTrial"), true

test "Methods", ->
    expect 6
    
    trialProperties = @trialObject.parameterizedTrial()
    equal trialProperties["delay"], 0
    equal trialProperties["duration"], 0
    equal trialProperties["startWithTrial"], true

    deepEqual @trialObject.returnRequired(), {"name": ""}
    ok @trialObject.returnOptions() instanceof Object
    ok @trialObject.allParameters() instanceof Object

test "Collection", ->

    expect 1

    collection = new PsychoCoffee.TrialObject.Collection

    model = collection.create()

    ok model instanceof PsychoCoffee.TrialObject.Model