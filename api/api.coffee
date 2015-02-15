fs = require 'fs'
dataconfig = require './dataconfig'
DiffTools = require '../app/utils/diff'
toothache = require 'toothache'
Joi = require 'joi'
mongodb = require 'mongodb'
bcrypt = require 'bcrypt'
boom = require 'boom'

defineREST = (plugin, model, model_name) ->
    # Create
    plugin.route
        method: "POST"
        path: "/api/#{ model_name }",
        config:
            handler: model.create

    # Get a resource, must use "id" parameter to refer to mongo"s "_id" field
    plugin.route
        method: "GET"
        path: "/api/#{ model_name }/{id}"
        config:
            handler: model.get

    # Get All
    plugin.route
        method: "GET"
        path: "/api/#{ model_name }"
        config:
            handler: model.find

    # Find, will search collection using payload for criteria
    plugin.route
        method: "POST"
        path: "/api/#{ model_name }/find"
        config:
            handler: model.find

    # Update, must use "id" parameter to refer to mongo"s "_id" field
    plugin.route
        method: "PUT"
        path: "/api/#{ model_name }/{id}"
        config:
            handler: model.update

    # Delete, must use "id" parameter to refer to mongo"s "_id" field
    plugin.route
        method: "DELETE"
        path: "/api/#{ model_name }/{id}"
        config:
            handler: model.del

module.exports = (server) ->
    MongoClient = mongodb.MongoClient
    MongoClient.connect "mongodb://#{ dataconfig.config.username }:#{ dataconfig.config.password }@#{ dataconfig.config.host }:#{ dataconfig.config.port }/#{ dataconfig.config.database }", (err, db) ->
        if err?
            throw err
        else
            console.log "Database connected at mongodb://#{ dataconfig.config.host }:#{ dataconfig.config.port }/#{ dataconfig.config.database }"
            User = toothache
                db: db
                collection: 'users'
                create:
                    payload: Joi.object().keys 
                        email: Joi.string().required()
                        password: Joi.string().required()
                    defaults:
                        access: 'normal'
                        activated: false
                        uId: true
                    bcrypt: 'password'
                    date: 'created'
                    access: "admin"
                read:
                    whitelist: ['email']
                    blacklist: ['password']
                    access: 'normal'
                update:
                    payload: Joi.object().keys
                        email: Joi.string()
                        password: Joi.string()
                    bcrypt: 'password'
                    date: 'updated'
                    access: 'normal'
                del:
                    access: 'normal'
                validationOpts:
                    abortEarly: false

            Experiment = toothache
                db: db
                collection: 'experiments'
                create:
                    payload: Joi.object().keys 
                        name: Joi.string().required()
                    defaults:
                        access: 'normal'
                        uId: true
                    date: 'created'
                    access: "normal"
                read:
                    access: 'normal'
                update:
                    date: 'updated'
                    access: 'normal'
                del:
                    access: 'normal'
                validationOpts:
                    abortEarly: false
                    allowUnknown: true

            ExperimentDataHandler = toothache
                db: db
                collection: 'experimentdatahandlers'
                create:
                    payload: {}
                    date: 'created'
                    access: "normal"
                read:
                    access: 'normal'
                update:
                    date: 'updated'
                    access: 'normal'
                del:
                    access: 'normal'
                validationOpts:
                    abortEarly: false
                    allowUnknown: true

            defineREST server, User, "user"
            defineREST server, Experiment, "experiment"
            defineREST server, ExperimentDataHandler, "experimentdatahandlers"

            ExperimentDataHandler.patch = (request, reply) ->
                collection = db.collection 'experimentdatahandlers'
                resource_id = request.params.id
                if request.method == 'get'
                    payload = request.query
                else
                    payload = request.payload
                collection.findOne "_id": mongodb.ObjectId(resource_id), (err, doc) ->
                    update = DiffTools.Merge(doc, payload)
                    collection.update "_id": mongodb.ObjectId(resource_id), {$set: update}, {}, (err, doc) ->
                        if not err?
                            return reply({error:null,message:'Updated successfully', patched: true})

            User.login = (request, reply) ->
                collection = db.collection "users"
                username = request.payload.username
                password = request.payload.password
                collection.findOne "email": username, (err, user) ->
                    if err
                        reply boom.badRequest(err)
                    if user
                        bcrypt.compare password, user.password, (err, isValid) ->
                            if isValid
                                reply user
                    else
                        reply boom.badRequest("User not found")

            # Add additional PATCH method for experimentdatahandler
            server.route
                method: "PATCH"
                path: "/api/experimentdatahandlers/{id}"
                config:
                    handler: ExperimentDataHandler.patch

            server.route
                method: "POST"
                path: "/api/users/login"
                config:
                    handler: User.login