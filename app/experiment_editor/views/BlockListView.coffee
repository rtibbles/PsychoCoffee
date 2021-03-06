'use strict'

Template = require '../templates/blocklist'
ItemTemplate = require '../templates/blocklistitem'
View = require './View'
ModelEditView = require './ModelEditView'

class BlockItemView extends View
    template: ItemTemplate

    events:
        "click .block": "click"
        "drop": "drop"

    drop: (event, index) ->
        collection = @model.collection
        collection.remove @model, silent: true
        collection.add @model, at: index

    click: (event) ->
        PsychoEdit.router.editSubItem @model.get("name")
        return false

    initialize: ->
        @listenTo @model, "change", @render


module.exports = class BlockListView extends View
    template: Template

    events:
        "click .addblock": "addBlock"

    initialize: ->
        @listenTo @collection, "add", @render
        @listenTo @collection, "remove", @render

    addBlock: ->
        newBlock = @collection.add({})
        newBlock.new = true
        modelEditView = new ModelEditView({model: newBlock})
        modelEditView.render()

    render: ->
        super
        for model in @collection.models
            view = new BlockItemView model: model, deleteable: true
            view.render()
            view.appendTo("#blocklist")
        @$("#blocklist").sortable
            stop: (event, ui) =>
                ui.item.trigger("drop", ui.item.index())