View = require './View'

module.exports = class ModalView extends View

    render: ->
        super
        $(".modal").show()

    remove: ->
        $(".modal").hide()
        super