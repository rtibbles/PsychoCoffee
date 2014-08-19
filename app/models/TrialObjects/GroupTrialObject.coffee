'use strict'

###
The group trial object acts as a special wrapper around
other trial objects to group behaviour or properties in
a privileged way.

One example might be for the randomization of buttons
across or participants or across trials. Two buttons would
be part of a group, and have their labels determined at
the button level - allowing their ordering to be
paramiterized.

As such, parameterizedAttributes on group object is
always ignored, and any arrays passed in as parameters
are assumed to be parameters for the children.
###

TrialObject = require("../TrialObject")

class Model extends TrialObject.Model
    
    relations: [
        type: Backbone.Many
        key: 'trialObjects'
        collectionType: TrialObject.Collection
    ]

    parameterizedTrial: (parameters) ->
        attributes = super()
        trialObjects = []
        for model, index in attributes.trialObjects.models
            localParameters = {}
            for key, value of parameters
                if value instanceof Array
                    localParameters[key] = value[index]
                else
                    localParameters[key] = value
            trialObjects.push model.parameterizedTrial(localParameters)
        attributes.trialObjects = trialObjects


module.exports =
    Model: Model