View = require './View'
DraggableView = require './DraggableView'
ManagerTemplate = require '../templates/filemanager'
ItemTemplate = require '../templates/fileitem'
PreviewTemplate = require '../templates/filepreview'

class FileItemView extends DraggableView

    template: ItemTemplate

    event:
        "click .fileitem": "selectFile"

    selectFile: ->
        return true


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
            url: "/files"
            thumbnailWidth: 80
            thumbnailHeight: 80
            parallelUploads: 20
            previewTemplate: PreviewTemplate()
            autoQueue: true
            previewsContainer: @$("#previews")[0]
            clickable: @$(".fileinput")[0]
        )

        @$("#previews").dropdown('toggle')
         
        @listenTo @dropzone, "totaluploadprogress", @updateProgressBar

        @listenTo @dropzone, "success", @uploadSuccess

        @listenTo @dropzone, "queuecomplete", @queueComplete

        _.defer @addAllFileViews

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

    addAllFileViews: =>
        for model in @collection.models
            @addFileView model