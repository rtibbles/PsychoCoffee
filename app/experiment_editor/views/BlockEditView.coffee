'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/blockedit'
ToolbarTemplate = require '../templates/trialobjecttoolbar'
ListTemplate = require '../templates/trialobjectlist'
ItemTemplate = require '../templates/trialobjectlistitem'
TrialObjectModelEditView = require './TrialObjectModelEditView'
View = require './View'

class TrialObjectToolbarView extends View
    template: ToolbarTemplate

    getRenderData: ->
        return trialObjects: PsychoEdit.trialObjects


class TrialObjectItemView extends View
    template: ItemTemplate

    events:
        "click .trialobject": "editTrialObjectModel"

    editTrialObject: ->
        editView = new TrialObjectModelEditView({model: @model})
        editView.appendTo("#overlay")

    initialize: ->
        @listenTo @model, "change", @render

class TrialObjectListView extends View
    template: ListTemplate

    initialize: ->
        @listenTo @collection, "add", @render
        @listenTo @collection, "remove", @render

    render: ->
        super
        for model in @collection.models
            view = new TrialObjectItemView model: model
            view.render()
            view.appendTo(".trialObjectList")


module.exports = class BlockEditView extends CodeGeneratorView
    template: Template

    events:
        "click .addtrialobject": "addTrialObject"
        
    render: ->
        super
        @toolbarView = new TrialObjectToolbarView()
        @toolbarView.render()
        @$("#block_editor").append @toolbarView.el
        @trialObjectListView = new TrialObjectListView(
            {collection: @model.get("trialObjects")})
        @trialObjectListView.render()
        @$("#block_editor").append @trialObjectListView.el

    addTrialObject: (event) ->
        type = event.target.id
        newTrialObject = @model.get("trialObjects").add({type: type})
        modelEditView = new TrialObjectModelEditView({model: newTrialObject})
        modelEditView.render()
        modelEditView.appendTo("#overlay")