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
        "click .trialObject": "editTrialObject"

    editTrialObject: ->
        editView = new TrialObjectModelEditView({model: @model})
        editView.render()

    initialize: ->
        @render()
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
            @$(".trialObjectList").append view.el


module.exports = class BlockEditView extends CodeGeneratorView
    template: Template

    events:
        "click .addtrialobject": "addTrialObject"
        
    render: ->
        super
        @toolbarView = new TrialObjectToolbarView()
        @$("#block_editor").append @toolbarView.el
        @toolbarView.render()
        @trialObjectListView = new TrialObjectListView(
            {collection: @model.get("trialObjects")})
        @$("#block_editor").append @trialObjectListView.el
        @trialObjectListView.render()

    addTrialObject: (event) ->
        subModel = event.target.id
        newTrialObject = @model.get("trialObjects").add({
            subModelTypeAttribute: subModel
        })
        newTrialObject.new = true
        modelEditView = new TrialObjectModelEditView({model: newTrialObject})
        modelEditView.render()