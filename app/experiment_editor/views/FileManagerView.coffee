View = require './View'
DraggableView = require './DraggableView'
ManagerTemplate = require '../templates/filemanager'
SelectTemplate = require '../templates/fileselect'
ItemTemplate = require '../templates/fileitem'
PreviewTemplate = require '../templates/filepreview'


class FileItemView extends DraggableView

    events:
        "click .folder-expand": "toggleFolder"
        "click .edit": "editItem"

    tagName: "li"

    template: ItemTemplate

    initialize: (options) =>
        @parent = options.parent
        @listenTo @model, "change", @render
        @listenTo @model, "change:slug", @updateChildPaths

    render: =>
        super
        @$el.droppable
            drop: @drop
            greedy: true
        _.defer @renderChildren

    returnElements: =>
        if @$(".selected").length == 0
            selected = @$el
        else
            selected = $('.selected')
        container = $('<div/>').attr('id', 'draggingContainer')
        container.append(selected.clone())
        container.data("ids", @model.id or @model.get("name"))

    renderChildren: =>
        if @model.has("children")
            for key, child of @model.get("children")
                @parent.addFileView child

    dragStart: (event, ui) =>
        super(event, ui)
        @parent.$(".selected").trigger "mousedown"

    drop: (event, ui) =>
        if ui
            console.log "Dropped in #{@constructor.name}"
            if $(ui.draggable).data("id")
                event.stopPropagation()
                id = $(ui.draggable).data("id")
                model = @global_dispatcher.eventDataTransfer[id]
                if model
                    if @model.has("children")
                        old_path = model.get("path") or ""
                        old_folder = @parent.folders[old_path]
                        old_children = old_folder.get("children")
                        delete old_children[model.get("name")]
                        old_folder.set "children", old_children
                        children = @model.get("children")
                        children[model.get("name")] = model
                        @model.set "children", children
                        @recurseUpdateFilePath(model, @model)
                        @model.trigger "change"
                        model.trigger "change"
                        old_folder.trigger "change"

    recurseUpdateFilePath: (node, parent) =>
        new_path = parent.get("path") + parent.get("slug")
        node.set("path", new_path)
        for key, child of node.get("children") or {}
            @recurseUpdateFilePath(child, node)

    toggleFolder: (event) =>
        value = @$(event.target).filter("span").attr("value") or
            @$(event.target).find("span").attr("value")
        if value == "p#{@model.get('path')}#{@model.get('slug')}"
            @model.set("open", !@model.get("open"))


    editItem: (callback) =>
        @editCallback = callback
        @$(".edit").prop("disabled", "disabled")
        name = @model.get("name")
        @$(".name").first().hide()
        @$(".name").first()
            .after("<input class='item-edit form-control \
            input-sm inline' value='#{name}' />")
        @$(".item-edit").keypress @finishEdit
        @$(".item-edit").focus()

    finishEdit: (event) =>
        if event.which == 13
            old_name = @model.get("name")
            new_name = @$(".item-edit").val()
            if new_name != "" and /[a-zA-Z0-9]+$/.test(new_name)
                @model.set
                    name: new_name
                    slug: new_name
                if _.isFunction @editCallback
                    @editCallback()
            else
                @$(".item-edit").addClass("has-error")
                    .popover
                        content: "<span class='label label-warning'>\
                            Please enter at least one \
                            alphanumeric character</span>"
                        trigger: 'focus'
                        html: true
                @$(".item-edit").popover("show")

    updateChildPaths: =>
        previous = @model.previous("slug")
        now = @model.get("slug")
        for key, child of @model.get("children")
            child.set("path", child.get("path").replace(previous, now))


module.exports = class FileManagerView extends View
    template: ManagerTemplate

    events:
        "click .cancel": "removeAllFiles"
        "click #fileLabel": "toggleFilePane"
        "click .item": "selectFile"
        "click .addfolder": "addFolder"

    selectFile: (event) =>
        if @single
            @$(".item").removeClass('selected')
        @$(event.target).parent(".item").toggleClass('selected')
        values = @$(".item.selected").map(-> $(@).attr("value")).get()
        for i, value of values
            if value.indexOf("path:") == 0
                values[i] = @fileNamesFromPath(value)
        values = _.flatten values
        if @single
            values = values[0]
        @$(".fileinput").attr("value", values or "")
        if @single
            @toggleFilePane()

    initialize: (options) ->
        @single = options.single
        @selector = options.selector
        if @selector
            @open = false
        @plural = "File" + if not @single then "s" else ""
        @file_title = if @selector then "Select " + @plural else "Manage Files"
        @field_id = options.field_id
        @collection = PsychoEdit.files
        @fileViews = {}
        @folderViews = {}
        @listenTo @collection, "add", @addToFolder

    getRenderData: ->
        return id: @field_id, file_title: @file_title

    render: ->
        if @selector
            @$el.html SelectTemplate @getRenderData()
            @$("#fileModal").append ManagerTemplate(@getRenderData())
        else
            super
        @dropzone = new Dropzone(@$("#fileupload")[0],
            url: "/files"
            thumbnailWidth: 80
            thumbnailHeight: 80
            parallelUploads: 20
            previewTemplate: PreviewTemplate()
            autoQueue: true
            previewsContainer: @$("#previews")[0]
            clickable: @$(".fileinput")[0]
            headers:
                "X-CSRF-Token": $('meta[name="csrf-token"]').attr('content')
        )

        @$("#previews").dropdown('toggle')
         
        @listenTo @dropzone, "totaluploadprogress", @updateProgressBar

        @listenTo @dropzone, "success", @uploadSuccess

        @listenTo @dropzone, "queuecomplete", @queueComplete

        _.defer @renderFileTree

    updateProgressBar: (progress) =>
        @$("#total-progress .progress-bar").width(progress + "%")

    uploadSuccess: (file) =>
        @$(file.previewElement).remove()
        file_id = JSON.parse(file.xhr.response).file_id
        if not @collection.get(file_id)?
            name = file.name
            extension = file.name.split('.').pop()
            model = @collection.add
                name: name
                file_id: file_id
                extension: extension
            model.preLoadFile()

    removeAllFiles: =>
        @dropzone.removeAllFiles(true)

    queueComplete: =>
        @updateProgressBar(0)

    addFolder: =>
        folder = new Backbone.Model
            path: ""
            name: ""
            slug: ""
            open: true
            children: {}
        view = @addFileView(folder)
        view.editItem =>
            children = @tree[""].get("children")
            children[folder.get("name")] = folder

    addToFolder: (model) =>
        folder = @folders[model.get('path') or ""]
        children = folder.get("children")
        children[model.get("name")] = model
        folder.set("children", children)
        @addFileView(model)

    addFileView: (model, root=false) =>
        view = new FileItemView
            model: model
            parent: @
        view.render()
        path = model.get('path') or ""
        @fileViews[path + model.get('name')]?.remove()
        @fileViews[path + model.get('name')] = view
        if root
            @$("#p-root").append view.el
        else
            @$("#p#{path}").append view.el
        return view

    renderFileTree: =>
        paths = _.uniq(
            (model.get("path") or "" for model in @collection.models))
        @folders = {}
        @tree = {}
        for path in paths
            node = @tree
            folder_path = ""
            slugs = path.split("__")
            if slugs[0]
                slugs.unshift("")
            for slug in slugs
                if not (slug of node)
                    children = {}
                    for file in @filesFromParent(folder_path + slug)
                        children[file.get("name")] = file
                    folder = new Backbone.Model
                        path: folder_path
                        name: slug or "All Files"
                        slug: slug
                        open: if slug=="" then true else false
                        children: children
                    folder_path += if folder_path then "__" + slug else slug
                    node[slug] = folder
                    @folders[folder_path] = folder
                node = node[slug].attributes.children
        if not @tree[""]
            @tree[""] = new Backbone.Model
                path: ""
                name: "All Files"
                slug: ""
                open: true
                children: {}
            @folders[""] = @tree[""]
        @addFileView(@tree[""], true)

    fileNamesFromPath: (path) =>
        @collection.filter((model) ->
            (model.get("path") or "").indexOf(path) == 0)
            .map (model) -> model.get("file_id")

    filesFromParent: (path) =>
        @collection.filter (model) ->
            (model.get("path") or "") == path

    toggleFilePane: ->
        @$("#fileModal").toggle()
        @open = not @open
        @$("#fileLabel").text(
            if @open then "Choose " + @plural else "Select " + @plural)
        if not @open
            @trigger "closed"