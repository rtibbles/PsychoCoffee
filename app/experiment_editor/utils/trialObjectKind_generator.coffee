'use strict'

import_TrialObjects = ->

    TrialObjects = []
    _.keys(PsychoCoffee.trialObjectTypeKeys).forEach (key) ->
        val = PsychoCoffee.trialObjectTypeKeys[key]
        model = PsychoCoffee[val].Model
        TrialObjects.push({"name": key, "modelname": val})
    return TrialObjects

module.exports = import_TrialObjects