'use strict'
LoginView = require '../views/LoginView'
ExperimentEditView = require '../views/ExperimentEditView'
ExperimentListView = require '../views/ExperimentListView'

module.exports = class MainRouter extends Backbone.Router
    routes:
        "experiments/": "experimentList"
        "login/": "login"
        "experiments/:experiment/": "experiment"
        "experiments/:experiment/blocks/:block/": "block"
        "experiments/:experiment/variables/(:block/)": "variables"
        "": "redirect"

    redirect: ->
        @navigate "experiments/", trigger: true, replace: true

    checkAuth: ->
        next = Backbone.history.fragment
        if PsychoEdit.session.get("user_id")==""
            url = "login/?next=" + next
            @navigate url, trigger: true, replace: true
            return true
        else
            return false

    login: ->
        loginView = new LoginView
        loginView.render()
        $("#editor_window").html loginView.el

    experimentList: ->
        if @checkAuth() then return true
        listView = new ExperimentListView
        listView.render()
        $("#editor_window").html listView.el

    experiment: (experiment) ->
        if @checkAuth() then return true
        if @editView?.model_id != experiment
            @editView?.remove()
            delete @editView
        if not @editView?
            @editView = new ExperimentEditView model_id: experiment
            $("#editor_window").html @editView.el
        return false

    editSubItem: (block_id, type) ->
        if not type?
            type = if @variableEditView? then "variables" else "blocks"
        if block_id?
            block_id = encodeURIComponent(block_id) + "/"
        else
            block_id = ""
        @navigate "experiments/#{@editView.model_id}/#{type}/#{block_id}",
            trigger: true

    block: (experiment, block) ->
        if @experiment(experiment) then return true
        block = decodeURIComponent(block)
        @editView.editBlock(block)

    variables: (experiment, block) ->
        if @experiment(experiment) then return true
        block = decodeURIComponent(block)
        @editView.editVariables(block)