# Base class for all views.
module.exports = class View extends Backbone.View

    template: ->
        return

    getRenderData: ->
        return @model?.attributes or {}

    render: =>
        console.debug "Rendering #{@constructor.name}"
        @$el.html @template @getRenderData()
        @afterRender()
        return @

    appendTo: (el) =>
        $(el).append(@el)

    afterRender: ->
        return