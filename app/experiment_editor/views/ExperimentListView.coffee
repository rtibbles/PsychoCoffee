'use strict'

Template = require '../templates/experimentlist'
ItemTemplate = require '../templates/experimentlistitem'
HomeTemplate = require '../templates/home'
View = require './View'
Experiment = require '../models/Experiment'
ModelEditView = require './ModelEditView'

class ExperimentItemView extends View

    template: ItemTemplate

    events:
        "click .experiment": "editExperiment"

    initialize: ->
        @listenTo @model, "change", @render

    editExperiment: ->
        PsychoEdit.router.navigate "experiments/" + @model.id + "/",
            trigger: true
        return false

module.exports = class ExperimentListView extends View

    template: Template

    events:
        "click .add-experiment": "addExperiment"

    initialize: =>
        @collection = new Experiment.Collection
        @listenTo @collection, "add", @renderExperiment
        @collection.fetch()

    render: ->
        @$el.html HomeTemplate()
        @$("#main").append @template @getRenderData()
        for model in @collection.models
            @renderExperiment model
        return @

    renderExperiment: (model) ->
        view = new ExperimentItemView model: model
        view.appendTo("#experiments")
        view.render()

    addExperiment: ->
        newExperiment = @collection.add({})
        newExperiment.new = true
        modelEditView = new ModelEditView({model: newExperiment})
        modelEditView.render()
        @listenToOnce modelEditView, "attributes_set", ->
            newExperiment.save()