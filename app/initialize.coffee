'use strict'
PsychoCoffee = window.PsychoCoffee = require './app/app'
nestedImport = require './utils/nestedImport'

# Load all modules in order automagically.
folderOrder = [
    'utils', 'routes', 'models',
    'views', 'templates'
  ]

folderOrder.forEach (folder) -> nestedImport folder, PsychoCoffee

$ ->
    PsychoCoffee.initialize()
    Backbone.history.start()