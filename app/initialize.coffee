'use strict'
PsychoCoffee = window.PsychoCoffee = require './app/app'
nestedImport = require './utils/nestedImport'
createjs.FlashPlugin.swfPath = "/widgets/SoundJS/"

# Load all modules in order automagically.
folderOrder = [
    'utils', 'routes', 'models',
    'views', 'templates'
  ]

folderOrder.forEach (folder) -> nestedImport folder, PsychoCoffee

$ ->
    PsychoCoffee.initialize()
    Backbone.history.start()