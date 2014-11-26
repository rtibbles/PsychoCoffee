'use strict'

Template = require '../templates/blocklist'
ItemTemplate = require '../templates/blocklistitem'
View = require './View'
BlockModelEditView = require './BlockModelEditView'

class BlockItemView extends View
    template: ItemTemplate

    events:
        "click .block": "editBlock"

    initialize: ->
        @listenTo @model, "change", @render

    editBlock: ->
        this.global_dispatcher.trigger("editBlock", @model)

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
        modelEditView = new BlockModelEditView({model: newBlock})
        modelEditView.render()

    render: ->
        super
        for model in @collection.models
            view = new BlockItemView model: model
            view.render()
            view.appendTo("#blocklist")