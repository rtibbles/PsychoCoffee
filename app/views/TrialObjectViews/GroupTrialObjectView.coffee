'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class GroupTrialObjectView extends TrialObjectView

    initialize: (options) =>
        super
        @instantiateSubViews("trialObjects",
            "TrialObjectView", @trialObjectViewType)
        @registerSubViewSubViews()

    preLoadTrialObject: (queue) =>
        for view in @subViewList
            view.preLoadTrialObject(queue)

    attach: (endpoints) ->
        for view in @subViewList
            view.attach(endpoints)

    activate: ->
        for view in @subViewList
            view.activate()
        super()

    deactivate: ->
        for view in @subViewList
            view.deactivate()
        super()

    render: ->
        return

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