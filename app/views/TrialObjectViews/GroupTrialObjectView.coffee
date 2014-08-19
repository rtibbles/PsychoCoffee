'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class GroupTrialObjectView extends TrialObjectView

    initialize: (options) =>
        super
        @instantiateSubViews("trialObjects",
            "TrialObjectView", @trialObjectViewType)
        @subViewList = _.values(@subViews)

    preLoadTrialObject: (queue) =>
        for view in @subViews
            view.preLoadTrialObject(queue)

    attach: (endpoints) ->
        for view in @subViews
            view.attach(endpoints)

    activate: ->
        for view in @subViews
            view.activate()
        super()

    deactivate: ->
        for view in @subViews
            view.deactivate()
        super()


    # Repeats code from TrialView - not DRY at all!
    trialObjectViewType: (model) ->
        elementType = model.get("subModelTypeAttribute") or
            PsychoCoffee.trialObjectTypeKeys[model.get("type")]

        # For this to work, any models subclassed from TrialObject must be named
        # ModelName, and the associated View must be named ModelNameView

        elementView = elementType + "View"

        try
            PsychoCoffee[elementView]
            elementView
        catch error
            console.debug error, "Unknown element type #{elementType}"