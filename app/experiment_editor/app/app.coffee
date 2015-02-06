'use strict'

generator = require "../utils/trialObjectKind_generator"
HomeView = require '../views/HomeView'

# The application bootstrapper.
PsychoEdit =
    initialize: ->
        dispatcher = _.extend({}, Backbone.Events, cid: "dispatcher")
        _.each [ Backbone.Collection::,
            Backbone.Model::,
            Backbone.View::,
            Backbone.Router:: ], (proto) ->
            # attaching a global dispatcher instance
            _.extend proto, global_dispatcher: dispatcher
        @global_dispatcher = dispatcher
        @global_dispatcher.eventDataTransfer = {}
        @trialObjects = generator()
        @homeView = new HomeView


module.exports = PsychoEdit