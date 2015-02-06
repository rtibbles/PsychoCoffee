'use strict'

Template = require '../templates/experimentlist'
ItemTemplate = require '../templates/experimentlistitem'
View = require './View'
Collection = require '../models/Experiment'
ModelEditView = require './ModelEditView'

class ExperimentItemView extends View

    template: ItemTemplate

    events:
        "click .experiment": "editExperiment"

    initialize: ->
        @listenTo @model, "change", @render

    editExperiment: ->
        @global_dispatcher.trigger("editExperiment", @model)

module.exports = class ExperimentListView extends View

    template: Template

    events:
        "click .add-experiment": "addExperiment"

    initialize: =>
        @collection = new Collection
        @listenTo @collection, "add", @render
        @collection.fetch()

    render: ->
        super
        for model in @collection.models
            view = new ExperimentItemView model: model
            view.appendTo("#experiments")
            view.render()

    addExperiment: ->
        newExperiment = @collection.add({})
        newExperiment.new = true
        modelEditView = new ModelEditView({model: newExperiment})
        modelEditView.render()
        @listenToOnce modelEditView, "attributes_set", ->
            console.log newExperiment
            newExperiment.save()