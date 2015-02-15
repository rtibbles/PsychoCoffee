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
        PsychoEdit.session.login
            email: email
            password: password
        ,
            success: (res) =>
                @global_dispatcher.trigger "login"
            error: (mod, res) =>
                @$("#email, #password").animate border: "2px solid red"