fs = require 'fs'
loopback = require 'loopback'
DataSource = require('loopback-datasource-juggler').DataSource
DiffTools = require '../../app/utils/diff'

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

    # Register models to data source
    experimentdatahandler = loopback.createModel "experimentdatahandler"
    experimentdatahandler.attachTo ds
    server.model experimentdatahandler

    experimentdatahandler.patch = (id, diff, callback) ->
        experimentdatahandler.findById id, (err, model) ->
            DiffTools.Merge(model, diff)
            console.log model.blockdatahandlers[0].trialdatalogs[0].trialeventlogs
            model.save (err, modeldata) ->
                if err
                    callback(null, false)
                else
                    callback(null, true)

    experimentdatahandler.remoteMethod(
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