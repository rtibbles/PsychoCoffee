'use strict'

generator = require "../utils/trialObjectKind_generator"
Session = require '../models/Session'
MainRouter = require '../routers/MainRouter'

# The application bootstrapper.
PsychoEdit =
    initialize: ->
        $.ajaxSetup
            beforeSend: (xhr) ->
                token = $('meta[name="csrf-token"]').attr('content')
                if token? then xhr.setRequestHeader('X-CSRF-Token', token)
        dispatcher = _.extend({}, Backbone.Events, cid: "dispatcher")
        _.each [ Backbone.Collection::,
            Backbone.Model::,
            Backbone.View::,
            Backbone.Router:: ], (proto) ->
            # attaching a global dispatcher instance
            _.extend proto, global_dispatcher: dispatcher
        @global_dispatcher = dispatcher
        @global_dispatcher.eventDataTransfer = {}
        @API = "/api"
        @session = new Session
        @trialObjects = generator()

        @session.checkAuth complete: =>
            @router = new MainRouter
            Backbone.history.start pushState: true, root: "/u/"


module.exports = PsychoEdit