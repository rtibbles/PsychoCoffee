'use strict'

module.exports = App.ExperimentRoute = Ember.Route.extend
  model: (params) ->
    return @store.find 'experiment', params.experiment_id

