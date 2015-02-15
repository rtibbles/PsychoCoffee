fs = require 'fs'
dataconfig = require './dataconfig'
Joi = require 'joi'
mongodb = require 'mongodb'
auth = require './auth'
mongoModels = require 'hapi-mongo-models'
User = require './models/User'
Experiment = require './models/Experiment'
ExperimentDataHandler = require './models/ExperimentDataHandler'


defineREST = (server, model, model_name, mode='try', routes=[]) ->

    default_routes = [
        method: "POST"
        path: "/api/#{ model_name }"
        handler: model.create
    ,
        method: "GET"
        path: "/api/#{ model_name }/{id}"
        handler: model.get
    ,
        method: "GET"
        path: "/api/#{ model_name }"
        handler: model.findObjects
    ,
        method: "POST"
        path: "/api/#{ model_name }/find"
        handler: model.findObjects
    ,
        method: "PUT"
        path: "/api/#{ model_name }/{id}"
        handler: model.updateObject
    ,
        method: "DELETE"
        path: "/api/#{ model_name }/{id}"
        handler: model.del
    ]

    routes = routes.concat default_routes

    for route in routes
        server.route
            method: route.method
            path: route.path
            config: auth.config(route.handler, mode)

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

    defineREST server, User, "users", 'required'
    defineREST server, Experiment, "experiments", 'required'
    defineREST server, ExperimentDataHandler, "experimentdatahandlers", 'try'

    # Add additional PATCH method for experimentdatahandler
    server.route
        method: "PATCH"
        path: "/api/experimentdatahandlers/{id}"
        config:
            handler: ExperimentDataHandler.patch