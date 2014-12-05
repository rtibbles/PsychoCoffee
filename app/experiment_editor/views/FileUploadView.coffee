View = require './View'
Template = require '../templates/fileupload'
PreviewTemplate = require '../templates/filepreview'

module.exports = class FileUploadView extends View
    template: Template

    events:
        "click .cancel": "removeAllFiles"

    initialize: (options) ->
        @collection = options.files

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
            clickable: @$(".fileinput-button")[0]
        )

        @$("#previews").dropdown('toggle')
         
        @listenTo @dropzone, "totaluploadprogress", @updateProgressBar

        @listenTo @dropzone, "success", @uploadSuccess

        @listenTo @dropzone, "queuecomplete", @queueComplete

    updateProgressBar: (progress) =>
        @$("#total-progress .progress-bar").width(progress + "%")

    uploadSuccess: (file) =>
        @$(file.previewElement).remove()
        @collection.add
            name: file.name
            extension: file.name.split('.').pop()

    removeAllFiles: =>
        @dropzone.removeAllFiles(true)

    queueComplete: =>
        @updateProgressBar(0)