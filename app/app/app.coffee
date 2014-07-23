'use strict'

# The application bootstrapper.
App =
    initialize: ->
        Router = require '../routes/router'

        # Instantiate the router
        @router = new Router()
        # Freeze the object
        Object.freeze? this

module.exports = App