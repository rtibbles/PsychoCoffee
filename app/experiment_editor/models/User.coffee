'use strict'

module.exports = class User extends Backbone.Model

    url: ->
        PsychoEdit.API + "/users"