fs = require 'fs'
loopback = require 'loopback'
DataSource = require('loopback-datasource-juggler').DataSource


module.exports = mountRestApi = (server) ->
    restApiRoot = server.get 'restApiRoot'

    ds = loopback.createDataSource('memory')

    # db = new DataSource
    #     "connector": "mongodb",
    #     "host": "localhost",
    #     "port": 27017,
    #     "username": "user",
    #     "password": "user",
    #     "database": "apitest",
    #     "debug": true

    Model = loopback.Model

    modelsToRegister = ["experimentdatahandler"]

    registeredModels = {}

    # Register models to data source
    modelsToRegister.forEach (modelName) ->
        if modelName
            registeredModels[modelName] = ds.createModel modelName
            # registeredModels[modelName].attachTo db
            server.model registeredModels[modelName]

    registeredModels["experimentdatahandler"].patch = (id, diff, cb) ->
        console.log id
        console.log diff
        cb(null, true)

    registeredModels["experimentdatahandler"].remoteMethod(
        "patch"
        accepts: [
            arg: 'id'
            type: 'any'
            description: 'Model id'
            required: true
            http:
                source: 'path'
        ,
            arg: 'diff'
            type: 'object'
            decription: "Model diff"
            http:
                source: 'body'
            ]
        returns: {arg: 'patched', type: 'boolean'}
        http: {verb: 'patch', path: '/:id'}
        )

    server.use restApiRoot, server.loopback.rest()