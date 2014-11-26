View = require './View'

module.exports = class ModalView extends View

    render: ->
        super
        $("#editor_window").append @el
        @$("#Modal").modal()
        @$("#Modal").modal('show')

    remove: ->
        @$("#Modal").modal('hide')
        super