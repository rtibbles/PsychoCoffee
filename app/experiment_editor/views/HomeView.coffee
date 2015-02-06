'use strict'

Template = require '../templates/home'
View = require './View'
LoginView = require './LoginView'
ExperimentEditView = require './ExperimentEditView'
ExperimentListView = require './ExperimentListView'

module.exports = class HomeView extends View

    template: Template

    initialize: ->
        super
        @listenTo @global_dispatcher, "editExperiment", @render
        @listenTo @global_dispatcher, "login", @render
        @appendTo("#editor_window")
        @render()

    render: (model) ->
        super
        if not PsychoEdit.user?
            loginView = new LoginView
            loginView.render()
            loginView.appendTo("#main")
        else if model?
            editView = new ExperimentEditView model: model
            editView.render()
            editView.appendTo("#editor_window")
        else
            listView = new ExperimentListView
            listView.render()
            listView.appendTo("#main")
