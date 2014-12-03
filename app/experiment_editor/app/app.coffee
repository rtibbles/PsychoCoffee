'use strict'

generator = require "../utils/trialObjectKind_generator"
ExperimentEditView = require '../views/ExperimentEditView'

# The application bootstrapper.
PsychoEdit =
    initialize: ->
        Backbone.Associations.EVENTS_NC = true
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
        @editView = new ExperimentEditView


module.exports = PsychoEdit