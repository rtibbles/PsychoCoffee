'use strict'

ModelEditView = require './ModelEditView'
DropableView = require './DropableView'
Template = require '../templates/parameterset'
FileManagerView = require './FileManagerView'

module.exports = class ParameterSetEditView extends DropableView
    template: Template

    events:
        # "click .add-variable": "addVariable"
        "change td": "updateData"
        "change .randomize": "updateRandomize"
        "change .datatype": "updateDataType"

    initialize: (options) ->
        @type = options.type
        @collection = @model.get("parameterSet").get(@type + "Parameters")
        @listenTo @collection, "add", @render
        @listenTo @collection, "remove", @render
        @listenTo @collection, "change", @render

    render: ->
        super
        @dropzone = new Dropzone(@$("#parameters")[0],
            url: "/files"
            acceptedFiles: ".csv"
            createImageThumbnails: false
            maxFiles: 1
            parallelUploads: 1
            autoProcessQueue: false
            addedfile: @parseCSV
            clickable: @$(".add-variable")[0]
        )
        subViews = {}
        for item in @$("span.file-menu")
            id = @$(item).attr("dataname")
            subViews[id] = new FileManagerView({
                selector: true
                field_id: id
            })
            subViews[id].render()
            @$(item).replaceWith(subViews[id].el)
            @listenTo subViews[id], "closed", =>
                model = @collection.get(id)
                value = @$("span.fileinput").attr("value").split(",")
                model.set("parameters", value)

    parseCSV: (file) =>
        Papa.parse(file,
            complete: (results) =>
                # First row is reserved for variable name
                data = results.data
                headers = data[0]
                parameters = data.slice(1)
                @collection.reset()
                parameters = parameters[0].map((col, i) ->
                    return parameters.map((row) ->
                        return row[i]))
                for i in [0...headers.length]
                    for dataType in [
                        "String"
                        "Colour"
                        "File"
                        "Boolean"
                        "Array"
                        "Number"
                    ]
                        if _.every(parameters[i], (item) =>
                            @validateData(item, dataType)[1])
                            paramType = dataType
                    @collection.create
                        name: headers[i]
                        dataType: paramType
                        parameters: parameters[i].map((item) =>
                            @validateData(item, paramType))
                return @collection
        )

    dragStart: (event, ui) =>
        name = $(event.target).attr("dataname")
        model = @collection.indexBy("name")[name]
        if model?
            $(event.target).draggable("widget").data("id", model.id)
            @global_dispatcher.eventDataTransfer[model.id] = model
        event?.stopPropagation()

    dragEnd: (event, ui) ->
        ui.helper.remove()
        event?.stopPropagation()

    drop: (event, ui) =>
        model = super(event, ui)
        if model.collection != @collection
            model.collection.remove model
        @collection.add model

    validateData: (newValue, dataType) ->
        switch dataType
            when "Number"
                newValue = Number(newValue)
                valid = not isNaN(newValue)
            when "Boolean"
                valid = true
                if newValue == "true"
                    newValue = true
                else if newValue == "false"
                    newValue = false
                else
                    valid = false
            when "String"
                valid = typeof newValue == "string"
            when "Colour"
                valid = /#[A-Fa-f0-9]{6}$/.test(newValue)
            when "Array"
                newValue = $.parseJSON(newValue)
                valid = _.isArray(newValue)
            when "File"
                valid = PsychoEdit.files.get(newValue)?
        [newValue, valid]

    updateData: (event, newValue) =>
        dataType = $(event.target).attr("datatype")
        [newValue, valid] = @validateData(newValue, dataType)
        if not valid
            return false
        name = $(event.target).attr("dataname")
        index = Number($(event.target).attr("dataindex"))
        model = @collection.indexBy("name")[name]
        parameters = model.get("parameters")
        while index >= parameters.length
            parameters.push ""
        parameters[index] = newValue
        model.set "parameters", parameters
        @render()
        @$("[dataname=#{name}][dataindex=#{index + 1}]").focus().click()

    updateRandomize: (event) =>
        name = $(event.target).attr("dataname")
        checked = $(event.target).prop("checked")
        @collection.indexBy("name")[name].set("randomized", checked)

    updateDataType: (event) =>
        name = $(event.target).attr("dataname")
        datatype = $(event.target).val()
        @collection.indexBy("name")[name].set("dataType", datatype)

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
                dataTypes: _.map _.find(model.requiredParameters(), (x) ->
                    x.name == "dataType").options, (x) ->
                    name: x
                    selected: x == model.get("dataType")
                files: model.get("dataType") == "File"
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