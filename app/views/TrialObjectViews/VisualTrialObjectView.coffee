'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class VisualTrialObjectView extends TrialObjectView

    attach: (endpoints) ->
        if not @object
            @render()
        @canvas = endpoints.canvas
        @object.setVisible false
        if @editor
            @lockControls()
            @listenTo @model, "change", @lockControls
            @object.on "modified", @objectToModel
        @canvas.add @object

    activate: ->
        if not @editor
            @object.hasControls = false
            @object.hasBorders = false
            @object.lockMovementX = @object.lockMovementY = true
        @object.setVisible true
        @addToClockChangeEvents("activated")
        @object.on "mousedown", (event) =>
            @trigger "click"
            @logEvent "click"
        super()

    deactivate: ->
        @object.setVisible false
        @addToClockChangeEvents("deactivated")
        @object.off "mousedown"
        super()

    objectToModel: (event) =>
        @cancel_render = true
        omit = (value for key, value of @lockPoints when @object[key])
        @model.setFromObject(@object)

    render: ->
        if not @cancel_render
            if not @object
                @object = new @object_type()
            @object.set @model.allParameters()
            @addToClockChangeEvents("change")
        else
            @cancel_render = false

    lockPoints:
        lockMovementX: "x"
        lockMovementY: "y"
        lockRotation: "angle"
        lockScalingX: "scaleX"
        lockScalingY: "scaleY"

    lockControls: =>
        for key, value of @lockPoints
            @object[key] = _.isFunction @model.attributes[value]