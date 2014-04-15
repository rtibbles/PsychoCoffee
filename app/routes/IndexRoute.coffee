'use strict'

module.exports = App.IndexRoute = Ember.Route.extend
  model: ->
    return ['red', 'yellow', 'blue']

