'use strict'

View = require './View'
Template = require 'templates/trial'

module.exports = class TrialView extends View
    template: Template

    initialize: =>
        super
        @instantiateSubViews("trialObjects",
            "TrialObjectView", @elementViewType)

    preLoadTrial: =>
        allModels = (value.preLoadTrialObject() for key, value of @subViews)
        loadingModels = (model for model in allModels when model)

    elementViewType: (model) ->
        elementType = model.get("subModelTypeAttribute")

        # For this to work, any models subclassed from TrialObject must be named
        # ModelName, and the associated View must be named ModelNameView

        elementView = elementType + "View"

        try
            PsychoCoffee[elementView]
            elementView
        catch error
            console.debug error, "Unknown element type #{elementType}"