module "Trial Model Tests",

    setup: =>
        window.trial = new PsychoCoffee.Trial.Model

test "Default values", ->
    expect 3

    equal window.trial.get("width"), 640
    equal window.trial.get("height"), 480
    ok window.trial.get("trialObjects") instanceof PsychoCoffee.TrialObject.Collection