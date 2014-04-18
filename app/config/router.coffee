'use strict'

module.exports = App.Router.map ->
    # @resource 'about'
    @route "experiment", path: "experiment/:experiment_id"