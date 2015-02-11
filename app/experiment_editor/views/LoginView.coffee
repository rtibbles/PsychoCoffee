'use strict'

Template = require '../templates/login'
View = require './View'
User = require '../models/User'

module.exports = class LoginView extends View
    template: Template

    events:
        "click .login-btn": "login"

    login: ->
        email = @$("#email").val()
        password = @$("#password").val()
        user = new User
            email: email
            password: password
        user.save().success =>
            PsychoEdit.user = user
            @global_dispatcher.trigger "login"