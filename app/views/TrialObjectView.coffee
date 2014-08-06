'use strict'

View = require './View'

module.exports = class TrialObjectView extends View

    preLoadTrialObject: ->
        if @model.get("file")
            @model.preloadFile()
            return @model
        else
            return null

    elementViewType: ->
        elementType = @model.get("subModelTypeAttribute")
        # For this to work, any models subclassed from TrialObject must be named
        # ModelName, and the associated View must be named ModelNameView

        elementView = elementType + "View"

        try
            PsychoCoffee[elementView]
        catch error
            console.debug error, "Unknown element type #{elementType}"