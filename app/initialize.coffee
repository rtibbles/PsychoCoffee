'use strict'
App = require './app/app'

# Load all modules in order automagically.
folderOrder = [
    'utils', 'routes', 'models',
    'views', 'templates'
  ]

folderOrder.forEach (folder) ->
  window.require.list().filter (module) ->
    return new RegExp('^' + folder + '/').test module
  .forEach (module) ->
    require(module)

$ ->
  App.initialize()
  Backbone.history.start()