'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/blockedit'
ToolbarTemplate = require '../templates/trialobjecttoolbar'
ListTemplate = require '../templates/trialobjectlist'
ItemTemplate = require '../templates/trialobjectlistitem'
ModelEditView = require './ModelEditView'
BlocklyView = require './BlocklyView'
View = require './View'
DraggableView = require './DraggableView'
DraggableListView = require './DraggableListView'

class TrialObjectToolbarView extends View
    template: ToolbarTemplate

    getRenderData: ->
        return trialObjects: PsychoEdit.trialObjects


class TrialObjectItemView extends DraggableView
    template: ItemTemplate

    events:
        "click .trialObject": "editTrialObject"

    editTrialObject: (event) ->
        editView = new ModelEditView
            model: @model
            deleteable: true
        editView.render()

    initialize: ->
        super
        @render()
        @listenTo @model, "change", @render

class TrialObjectListView extends DraggableListView
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
        @toolbarView = new TrialObjectToolbarView
        @trialObjectListView = new TrialObjectListView
            collection: @model.get("trialObjects")
        @blocklyView = new BlocklyView
            model: @model
            el: @$("#block-code")
        @blocklyView.render()
        @$("#trialObjects").prepend @trialObjectListView.el
        @trialObjectListView.render()
        @$("#trialObjects").prepend @toolbarView.el
        @toolbarView.render()
        @listenTo @, "appended", @blocklyView.injectBlockly

    addTrialObject: (event) ->
        subModel = event.target.id
        newTrialObject = @model.get("trialObjects").add({
            subModelTypeAttribute: subModel
        })
        newTrialObject.new = true
        modelEditView = new ModelEditView
            model: newTrialObject
        modelEditView.render()