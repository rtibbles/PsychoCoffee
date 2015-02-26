'use strict'

ModelEditView = require './ModelEditView'
View = require './View'
Template = require '../templates/parameterset'

module.exports = class ParameterSetEditView extends View
    template: Template

    events:
        "click .add-variable": "addVariable"
        "change td": "updateData"
        "change .randomize": "updateRandomize"

    initialize: (options) ->
        @type = options.type
        @collection = @model.get("parameterSet").get(@type + "Parameters")
        @listenTo @collection, "add", @render
        @listenTo @collection, "remove", @render
        @listenTo @collection, "change", @render

    render: ->
        super
        @$(".parameter-table").editableTableWidget
            editor: $("<input id='table-edit'>")
        @$("#table-edit").keydown (e) ->
            if e.which == 13
                $("td:focus").trigger("enter_pressed")
        @$("td").on "enter_pressed", (e) =>
            target = $(e.target)
            next_cell = target.parent().next().children().eq(target.index())
            if next_cell.length > 0
                next_cell.focus()
                next_cell.click()
        @$('.parameter-table td').on 'validate', (evt, newValue) ->
            dataType = $(evt.target).attr("datatype")
            console.log dataType
            switch dataType
                when "Number"
                    return not isNaN(Number(newValue))
                when "Boolean"
                    return newValue == "true" or newValue == "false"
                when "String"
                    return typeof newValue == "string"
                when "Colour"
                    return /#[A-Fa-f0-9]{6}$/.test(newValue)
                when "Array"
                    return _.isArray(newValue)
                when "File"
                    return PsychoEdit.files.get(newValue)?


    updateData: (event) =>
        name = $(event.target).attr("dataname")
        index = Number($(event.target).attr("dataindex"))
        model = @collection.indexBy("name")[name]
        parameters = model.get("parameters")
        while index >= parameters.length
            parameters.push ""
        parameters[index] = $(event.target).text()
        model.set "parameters", parameters
        @render()
        @$("[dataname=#{name}][dataindex=#{index + 1}]").focus().click()

    updateRandomize: (event) =>
        name = $(event.target).attr("dataname")
        checked = $(event.target).prop("checked")
        @collection.indexBy("name")[name].set("randomized", checked)

    addVariable: ->
        model = @collection.create()
        modelEditView = new ModelEditView({model: model})
        modelEditView.render()

    getRenderData: ->
        type: @type
        title: @type + " variables"
        description: @getDescription()
        rows: @generateData()
        randomizable: @model.get("randomized")?
        model: @model.attributes

    generateData: ->
        if @collection.models.length == 0
            return false
        rows = []
        max_length = 0
        row = []
        row.push name: ""
        for model in @collection.models
            row.push
                name: model.get("name")
                randomizable: true
                randomized: model.get("randomized")
            length = model.get("parameters").length
            max_length = if length > max_length then length else max_length
        rows.push row
        for i in [0..max_length]
            row = []
            row.push
                value: i + 1
                index: i
                name: ""
            for model in @collection.models
                parameter = model.get("parameters")[i]
                row.push
                    value: parameter or ""
                    index: i
                    name: model.get("name")
                    dataType: model.get("dataType")
            rows.push row
        return rows

    getDescription: ->
        switch @type
            when "experiment"
                "These variables will be randomized across participants - \
                each participant will only see one of these possible values"
            when "trial"
                "These variables will be randomized within participants - \
                each participant will see some or all of these possible values"