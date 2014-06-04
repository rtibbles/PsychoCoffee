'use strict'

# The application bootstrapper.
App =
  initialize: ->
    HomeView = require '../views/HomeView'
    Router = require '../routes/router'

    # Ideally, initialized classes should be kept in controllers & mediator.
    # If you're making big webapp, here's more sophisticated skeleton
    # https://github.com/paulmillr/brunch-with-chaplin
    @homeView = new HomeView()

    # Instantiate the router
    @router = new Router()
    # Freeze the object
    Object.freeze? this

module.exports = App