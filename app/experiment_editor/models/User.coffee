'use strict'

module.exports = class User extends Backbone.Model

    idAttribute: "_id"
    
    url: ->
        PsychoEdit.API + "/users"