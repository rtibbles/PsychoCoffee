'use strict'
PsychoCoffee = window.PsychoCoffee = require './app/app'
nestedImport = require './utils/nestedImport'
nestedSelectiveImport = require '../utils/nestedSelectiveImport'
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

# A convenience method for specifying the 'type' of
# a trial object by a short hand type.
PsychoCoffee.trialObjectTypeKeys =
    _.invert nestedSelectiveImport('models/TrialObjects', "Type")

$ ->
    PsychoCoffee.initialize()
    Backbone.history.start()