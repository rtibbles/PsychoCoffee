fs = require 'fs'
loopback = require 'loopback'
DataSource = require('loopback-datasource-juggler').DataSource


module.exports = mountRestApi = (server) ->
    restApiRoot = server.get 'restApiRoot'
    server.use restApiRoot, server.loopback.rest()

    db = new DataSource 'mongodb'
    
    Model = loopback.Model

    registeredModels = {}

    # Register models to data source
    fs.readdirSync(__dirname + "/../../app/models/").forEach (modelFile) ->
        modelName = modelFile.split(".")[0].toLowerCase()
        if modelName
            console.log modelName
            registeredModels[modelName] = Model.extend modelName
            registeredModels[modelName].attachTo db
            server.model registeredModels[modelName]