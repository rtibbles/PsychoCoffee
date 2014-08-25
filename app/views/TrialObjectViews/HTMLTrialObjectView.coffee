'use strict'

TrialObjectView = require '../TrialObjectView'

module.exports = class HTMLTrialObjectView extends TrialObjectView

    className: "trial-object"

    attach: (endpoints) ->
        @$el.css "visibility", "hidden"
        @appendTo endpoints.elements
        @positionElement()

    activate: ->
        @$el.css "visibility", "visible"
        super()

    deactivate: ->
        @$el.css "visibility", "hidden"
        super()

    positionElement: ->
        switch @model.get("originX")
            when "left" then @$el.css "left", @model.get("x")
            when "right" then @$el.css "right", @model.get("x")
            when "center"
                @$el.css "left", @model.get("x") - @$el.width()/2

        switch @model.get("originY")
            when "top" then @$el.css "top", @model.get("y")
            when "bottom" then @$el.css "bottom", @model.get("y")
            when "center"
                @$el.css "top", @model.get("y") - @$el.height()/2


    render: ->
        @$el.html @template @model.allParameters()
        @positionElement()