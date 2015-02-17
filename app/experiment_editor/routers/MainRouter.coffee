'use strict'
LoginView = require '../views/LoginView'
ExperimentEditView = require '../views/ExperimentEditView'
ExperimentListView = require '../views/ExperimentListView'

module.exports = class MainRouter extends Backbone.Router
    routes:
        "experiments": "experimentList"
        "login": "login"
        "experiments/:experiment": "experiment"
        "": "redirect"

    redirect: ->
        @navigate "experiments", trigger: true, replace: true

    checkAuth: (next) ->
        if PsychoEdit.session.get("user_id")==""
            url = "login"
            if next?
                url += "?next=" + next
            @navigate "login", trigger: true, replace: true
            return true
        else
            return false

    login: ->
        loginView = new LoginView
        loginView.render()
        $("#editor_window").html loginView.el

    experimentList: ->
        if @checkAuth("experiments") then return true
        listView = new ExperimentListView
        listView.render()
        $("#editor_window").html listView.el

    experiment: (experiment) ->
        if @checkAuth("experiments/" + experiment) then return true
        editView = new ExperimentEditView model_id: experiment
        editView.render()
        $("#editor_window").html editView.el