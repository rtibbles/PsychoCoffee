'use strict'

View = require './View'
Template = require 'templates/trial'

module.exports = class TrialView extends View
    template: Template

    initialize: =>
        super
        @instantiateSubViews("trialObjects",
            "TrialObjectView", @trialObjectViewType)

    preLoadTrial: (queue) =>
        for key, view of @subViews
            view.preLoadTrialObject(queue)

    trialObjectViewType: (model) ->
        elementType = model.get("subModelTypeAttribute")

        # For this to work, any models subclassed from TrialObject must be named
        # ModelName, and the associated View must be named ModelNameView

        elementView = elementType + "View"

        try
            PsychoCoffee[elementView]
            elementView
        catch error
            console.debug error, "Unknown element type #{elementType}"

    startTrial: ->
        @createStage()
        for key, view of @subViews
            view.attach stage: @stage, hidden: @$("#trial-hidden")

    createStage: ->
        @model.set container: "trial-draw"
        @stage = new Kinetic.Stage @model.attributes