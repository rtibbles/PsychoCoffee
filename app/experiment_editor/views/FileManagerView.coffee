View = require './View'
DraggableView = require './DraggableView'
ManagerTemplate = require '../templates/filemanager'
SelectTemplate = require '../templates/fileselect'
ItemTemplate = require '../templates/fileitem'
FolderTemplate = require '../templates/folderitem'
PreviewTemplate = require '../templates/filepreview'

class FileItemView extends View

    tagName: "li"

    template: ItemTemplate

class FolderItemView extends View

    tagName: "li"

    template: FolderTemplate

    render: ->
        @$el.html template(@model)

module.exports = class FileManagerView extends View
    template: ManagerTemplate

    events:
        "click .cancel": "removeAllFiles"
        "click #fileLabel": "toggleFilePane"
        "click .item": "selectFile"

    selectFile: (event) ->
        @$(event.target).toggleClass('selected')
        values = @$(".item.selected").map(-> $(@).attr("value")).get()
        if @single
            values = values[0]
        @$(".fileinput").attr("value", values or "")
        @toggleFilePane()

    initialize: (options) ->
        @single = options.single
        @file_title = if options.single then "Select File" else "Manage Files"
        @field_id = options.field_id
        @collection = PsychoEdit.files
        @listenTo @collection, "add", @addFileView

    getRenderData: ->
        return id: @field_id, file_title: @file_title

    render: ->
        if @single
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
        if not @collection.get(file.name)?
            model = @collection.add
                name: file.name
                file_id: JSON.parse(file.xhr.response).file_id
                extension: file.name.split('.').pop()
            model.preLoadFile()

    removeAllFiles: =>
        @dropzone.removeAllFiles(true)

    queueComplete: =>
        @updateProgressBar(0)

    addFileView: (model) ->
        view = new FileItemView model: model
        view.render()
        path = model.get('path') or "__"
        @$("#p#{path}").append view.el

    addFolderView: (object) ->
        view = new FolderItemView model: object
        view.render()
        @$("#p#{object.path}").append view.el

    addAllFileViews: =>
        for model in @collection.models
            @addFileView model

    renderFolders: =>
        paths = _.uniq(
            (model.get("path") or "__" for model in @collection.models))
        @folders = {}
        @tree = {}
        for path in paths
            node = @tree
            folder_path = "__"
            for slug in path.split("__")
                if slug != ""
                    folder =
                        path: folder_path
                        name: slug
                        open: false
                        children: {}
                    folder_path += slug + "__"
                    if not slug of node
                        node[slug] = folder
                        @folders[folder_path] = folder
                    node = node[slug].children
        for key, value of @folders
            addFolderView(value)

    renderFileTree: =>
        @renderFolders()
        @addAllFileViews()

    toggleFilePane: ->
        @$("#fileModal").toggle()