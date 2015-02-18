fs = require 'fs'
dataconfig = require './dataconfig'
Joi = require 'joi'
auth = require './auth'
mongoModels = require 'hapi-mongo-models'
User = require './models/User'
Experiment = require './models/Experiment'
ExperimentDataHandler = require './models/ExperimentDataHandler'
fileupload = require './fileupload'
_ = require 'underscore'


defineREST = (server, model, model_name, routes=[]) ->

    default_routes = [
        method: "POST"
        path: "/api/#{ model_name }"
        handler: "create"
    ,
        method: "GET"
        path: "/api/#{ model_name }/{id}"
        handler: "get"
    ,
        method: "GET"
        path: "/api/#{ model_name }"
        handler: "findObjects"
    ,
        method: "POST"
        path: "/api/#{ model_name }/find"
        handler: "findObjects"
    ,
        method: "PUT"
        path: "/api/#{ model_name }/{id}"
        handler: "updateObject"
    ,
        method: "DELETE"
        path: "/api/#{ model_name }/{id}"
        handler: "del"
    ]

    routes = routes.concat default_routes

    for route in routes
        mode = if route.handler in model.authMethods then "required" else "try"
        server.route
            method: route.method
            path: route.path
            config: auth.config(model[route.handler], mode)

module.exports = (server) ->

    mongoModels.BaseModel.connect
        url: "mongodb://#{ dataconfig.config.username }:\
#{ dataconfig.config.password }@\
#{ dataconfig.config.host }:\
#{ dataconfig.config.port }/\
#{ dataconfig.config.database }"
    , (err) ->
        if err
            console.log 'Failed to connect to database'

    auth.register(server)
    fileupload(server)

    defineREST server, User, "users"
    defineREST server, Experiment, "experiments"
    defineREST server, ExperimentDataHandler, "experimentdatahandlers"

    # Add additional PATCH method for experimentdatahandler
    server.route
        method: "PATCH"
        path: "/api/experimentdatahandlers/{id}"
        config:
            handler: ExperimentDataHandler.patch

    server.route
        method: "GET"
        path: "/validate/{activation_id}"
        config:
            handler: User.verifyEmail

    server.route
        method: 'GET'
        path: '/previewexperiment/{experiment_id}'
        handler: (request, reply) ->
            experiment_id = request.params.experiment_id
            experiment = Experiment.findById experiment_id, (err, result) ->
                if err
                    reply err
                else if _.isEmpty result
                    reply boom.notFound("Experiment not found")
                else
                    result = Experiment.filter(result)
                    return reply.view 'experiment_preview',
                        experiment_model: JSON.stringify(result)