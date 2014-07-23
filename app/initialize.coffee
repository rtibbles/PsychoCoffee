'use strict'
App = require './app/app'
nestedImport = require './utils/nestedImport'

# Load all modules in order automagically.
folderOrder = [
    'utils', 'routes', 'models',
    'views', 'templates'
  ]

folderOrder.forEach nestedImport

$ ->
    App.initialize()
    Backbone.history.start()