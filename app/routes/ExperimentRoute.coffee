'use strict'

module.exports = App.ExperimentRoute = Ember.Route.extend
  model: ->
    return ['red', 'yellow', 'blue']

