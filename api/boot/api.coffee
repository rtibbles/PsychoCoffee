requirejs = require 'requirejs'
fs = require 'fs'
loopback = require 'loopback'
DataSource = require('loopback-datasource-juggler').DataSource
DiffTools = requirejs 'cs!./app/utils/diff'
database = require '../datasource'

module.exports = mountRestApi = (server) ->
    restApiRoot = server.get 'restApiRoot'

    # ds = loopback.createDataSource('memory')

    db = new DataSource database.config

    # Register models to data source
    experimentdatahandler = loopback.createModel "experimentdatahandler"
    experimentdatahandler.attachTo db
    server.model experimentdatahandler

    experimentdatahandler.patch = (id, diff, callback) ->
        experimentdatahandler.findById id, (err, model) ->
            DiffTools.Merge(model, diff)
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