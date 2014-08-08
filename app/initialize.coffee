'use strict'
PsychoCoffee = window.PsychoCoffee = require './app/app'
nestedImport = require './utils/nestedImport'
createjs.FlashPlugin.swfPath = "/widgets/SoundJS/"
createjs.Sound.registerPlugins [
    createjs.WebAudioPlugin
    createjs.HTMLAudioPlugin
    createjs.FlashPlugin
    ]

# Load all modules in order automagically.
folderOrder = [
    'utils', 'routes', 'models',
    'views', 'templates'
  ]

folderOrder.forEach (folder) -> nestedImport folder, PsychoCoffee

$ ->
    PsychoCoffee.initialize()
    Backbone.history.start()