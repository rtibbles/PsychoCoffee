hapi = require 'hapi'
path = require 'path'

api = require './api/api'

app = new hapi.Server
    connections:
        routes:
            files:
                relativeTo: __dirname

app.connection port: 3000

app.route
    method: 'GET'
    path: '/{param*}'
    handler:
        directory:
            path: 'public'
            index: true

# boot scripts mount components like REST API
api app

exports.startServer = (port, path, callback) ->
    app.start ->
        console.log('Web server listening at: %s', app.info.uri);

if require.main == module
    app.start ->
        console.log('Web server listening at: %s', app.info.uri);