# require 'lib/view_helper'

# Base class for all views.
module.exports = class View extends Backbone.View
    initialize: (options) =>
        super
        @clock = options.clock
        if @clock
            console.log "Rendering #{@constructor.name} - #{@clock.getTime()}ms"

    template: ->
        return

    getRenderData: ->
        return @model?.attributes or {}

    render: =>
        # console.debug "Rendering #{@constructor.name}"
        @$el.html @template @getRenderData()
        @afterRender()
        return @

    appendTo: (el) =>
        $(el).append(@el)

    instantiateSubViews: (key, viewType, viewFunction) =>
        @subViews = {}
        for model in @model.get(key).models
            if viewFunction then viewType = viewFunction(model)
            @subViews[model.id] = new PsychoCoffee[viewType]
                model: model
                clock: @clock

    afterRender: ->
        return