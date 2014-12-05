'use strict'

window.PsychoEdit = require './app/app'

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
        when "File"
            type = "file"
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