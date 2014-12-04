# require 'lib/view_helper'

# Base class for all views.
module.exports = class View extends Backbone.View
    initialize: (options) =>
        super
        @clock = options?.clock
        @user_id = options?.user_id
        @injectedParameters = options?.parameters
        @editor = options?.editor

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

    instantiateSubViews: (key, viewType, viewFunction, options={}) =>
        for model in @model?.get(key).models or []
            if viewFunction? then viewType = viewFunction(model)
            @instantiateSubView(model, viewType, model.id, options)
        @subViewList = _.values(@subViews)

    instantiateSubView: (model, viewType, id, options={}) =>
        if not @subViews
            @subViews = {}
        options = _.extend(
            options
            model: model
            clock: @clock
            user_id: @user_id)
        @subViews[id] = new PsychoCoffee[viewType] options

    registerSubViewSubViews: ->
        for subView in @subViewList
            for key, value of subView.subViews
                @subViews[key] = value
        @subViewList = _.values(@subViews)

    afterRender: ->
        return