module "Trial Model Tests",

    setup: ->
        @trial = new PsychoCoffee.Trial.Model

test "Default values", ->
    expect 1

    ok @trial.get("trialObjects") instanceof PsychoCoffee.TrialObject.Collection