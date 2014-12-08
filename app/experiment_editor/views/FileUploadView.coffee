View = require './View'
MultiTemplate = require '../templates/multiplefileupload'
SingleTemplate = require '../templates/singlefileupload'
PreviewTemplate = require '../templates/filepreview'

module.exports = class FileUploadView extends View

    events:
        "click .cancel": "removeAllFiles"

    initialize: (options) ->
        @field_id = options.field_id
        @collection = PsychoEdit.files
        if options.single
            @single = true
            @template = SingleTemplate
        else
            @template = MultiTemplate

    getRenderData: ->
        return id: @field_id

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