module "Trial Model Tests",

    setup: ->
        @trial = new PsychoCoffee.Trial.Model

test "Default values", ->
    expect 3

    equal @trial.get("width"), 640
    equal @trial.get("height"), 480
    ok @trial.get("trialObjects") instanceof PsychoCoffee.TrialObject.Collection