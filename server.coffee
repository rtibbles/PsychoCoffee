hapi = require 'hapi'
path = require 'path'
dataconfig = require './api/dataconfig'

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

app.route
    method: 'GET'
    path: '/media/{param*}'
    handler:
        directory:
            path: dataconfig.filestore.root

# boot scripts mount components like REST API
api app

exports.startServer = (port, path, callback) ->
    app.start ->
        console.log('Web server listening at: %s', app.info.uri);

if require.main == module
    app.start ->
        console.log('Web server listening at: %s', app.info.uri);