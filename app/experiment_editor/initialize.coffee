'use strict'

window.PsychoEdit = require './app/app'

(->
    # attaching the Events object to the dispatcher variable
    dispatcher = _.extend({}, Backbone.Events, cid: "dispatcher")
    _.each [ Backbone.Collection::,
        Backbone.Model::,
        Backbone.View::,
        Backbone.Router:: ], (proto) ->
        # attaching a global dispatcher instance
        _.extend proto, global_dispatcher: dispatcher
)()

Handlebars.registerHelper 'modelinput', (context, options) ->
    ret = "<div class='input-group'>"

    type = context.type
    value = context.value

    switch context.type
        when "Number"
            type = "number"
        when "Boolean"
            type = "checkbox"
            value = if value then "true' checked='checked" else ""
        when "Colour"
            type = "color"
        else type = "text"


    ret = ret + "<span class='input-group-addon'>" +
        context.name + "</span><input type='" +
        type + "' class='form-control' id='" +
        context.name + "' value='" +
        value + "'" +
        if context.required then "required='required'" else ""
    ret = ret + "/>"

    return ret + "</div><br>"

$ ->
    PsychoEdit.initialize()