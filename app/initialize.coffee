'use strict'

window.App = require('config/app')
require('config/router')
require('config/store')

App.ApplicationAdapter = DS.FixtureAdapter.extend()

App.Router.reopen
  location: 'auto'

# Load all modules in order automagically. Ember likes things to work this
# way so everything is in the App.* namespace.
folderOrder = [
    'utils', 'initializers', 'mixins', 'routes', 'models',
    'views', 'controllers', 'helpers',
    'templates', 'components'
  ]

folderOrder.forEach (folder) ->
  window.require.list().filter (module) ->
    return new RegExp('^' + folder + '/').test module
  .forEach (module) ->
    require(module)