'use strict'

module.exports = class TrialObjectView extends Backbone.View
    elementViewType: ->
        elementType = this.get('context.model').constructor.toString()
        # For this to work, any models subclassed from TrialObject must be named
        # ModelName, and the associated View must be named ModelNameView

        elementView = elementType.split(".")[1] += "View"

        try
            App[elementView]
        catch error
            throw "Unknown element type #{elementType}"