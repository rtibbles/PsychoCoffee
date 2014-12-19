View = require './View'
DraggableView = require './DraggableView'
ManagerTemplate = require '../templates/filemanager'
ItemTemplate = require '../templates/fileitem'
PreviewTemplate = require '../templates/filepreview'

class FileItemView extends DraggableView

    template: ItemTemplate


module.exports = class FileManagerView extends View
    template: ManagerTemplate

    events:
        "click .cancel": "removeAllFiles"

    initialize: (options) ->
        @file_title = if options.single then "Select File" else "Manage Files"
        @field_id = options.field_id
        @collection = PsychoEdit.files
        @listenTo @collection, "add", @addFileView

    getRenderData: ->
        return id: @field_id, file_title: @file_title

    render: ->
        super
        @dropzone = new Dropzone(@$("#fileupload")[0],
            url: "/api/containers/test/upload"
            thumbnailWidth: 80
            thumbnailHeight: 80
            parallelUploads: 20
            previewTemplate: PreviewTemplate()
            autoQueue: true
            previewsContainer: @$("#previews")[0]
            clickable: @$(".fileinput")[0]
        )

        for model in @collection.models
            @addFileView model

        @$("#previews").dropdown('toggle')
         
        @listenTo @dropzone, "totaluploadprogress", @updateProgressBar

        @listenTo @dropzone, "success", @uploadSuccess

        @listenTo @dropzone, "queuecomplete", @queueComplete

    updateProgressBar: (progress) =>
        @$("#total-progress .progress-bar").width(progress + "%")

    uploadSuccess: (file) =>
        @$(file.previewElement).remove()
        model = @collection.add
            name: file.name
            extension: file.name.split('.').pop()
        model.preLoadFile()
        if @single
            @$(".fileinput").html(file.name).attr("value", file.name)

    removeAllFiles: =>
        @dropzone.removeAllFiles(true)

    queueComplete: =>
        @updateProgressBar(0)

    addFileView: (model) ->
        view = new FileItemView model: model
        view.render()
        view.appendTo("#filelist")