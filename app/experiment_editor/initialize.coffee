'use strict'

Dropzone.autoDiscover = false
window.PsychoEdit = require './app/app'

Handlebars.registerHelper 'modelinput', (context, options) ->
    ret = "<div class='input-group'>"

    type = context.type
    value = context.value
    options = context.options

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

    ret = ret + "<span class='input-group-addon'>#{context.name}</span>"
    if options?
        ret += "<select type='"
    else
        ret += "<input type='"
    ret += "#{type}' class='form-control' id='#{context.name}'"
    ret += if context.required then " required='required'" else ""
    if options?
        ret += ">"
        for option in options
            ret += "<option value='#{option[1]}'" +
                if option[1] == context.default then " selected" else ""
            ret += ">#{option[1]}</option>"
        ret += "</select>"
    else
        ret +=  " value='#{value}'/>"

    return ret + "</div><br>"

Backbone.history.relativeUrl = (fragment) ->
    Backbone.history.root + Backbone.history.fragment + fragment

$ ->
    PsychoEdit.initialize()