# Base class for all views.
module.exports = class View extends Backbone.View

    initialize: ->
        @subViews = {}

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

    close: ->
        console.debug "Closing #{@constructor.name}"
        for key, value of @subViews
            if _.isFunction value.close
                value.close()
            else
                value.remove()