'use strict'

Template = require '../templates/login'
CreatedTemplate = require '../templates/accountcreated'
HomeTemplate = require '../templates/home'
View = require './View'
User = require '../models/User'

module.exports = class LoginView extends View
    template: Template

    events:
        "click .login-btn": "login"
        "click .create-btn": "create"

    initialize: ->
        super
        test = /next=([a-zA-Z0-9/]+)(&|$)/
        @next_view = (test.exec(window.location.search) or ["", ""])[1]

    login: ->
        email = @$("#email").val()
        password = @$("#password").val()
        PsychoEdit.session.login
            email: email
            password: password
        ,
            success: (res) =>
                PsychoEdit.router.navigate @next_view, trigger: true

            error: (mod, res) =>
                @$("#email, #password").animate border: "2px solid red"

    create: ->
        email = @$("#email").val()
        password = @$("#password").val()
        user = new User
            email: email
            password: password
        user.save {},
            success: (res) =>
                @$el.html CreatedTemplate()
            error: (mod, res) =>
                @$("#email, #password").animate border: "2px solid red"
                @$(".input-group").append("<span>Credentials invalid</span>")

    render: ->
        @$el.html HomeTemplate()
        @$("#main").append @template @getRenderData()
        return @