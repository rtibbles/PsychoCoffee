'use strict'

# The application bootstrapper.
PsychoCoffee =
    initialize: ->
        Router = require '../routes/router'

        # Instantiate the router
        @router = new Router()
        # Freeze the object
        Object.freeze? this

module.exports = PsychoCoffee