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


app.views
    relativeTo: __dirname
    path:  'api/templates'
    engines:
        hbs: require 'handlebars'

app.register register: require('crumb'), options: restful: true, (err) ->
    if err
        throw err

app.route
    method: 'GET'
    path: '/{param*}'
    handler: (request, reply) ->
        return reply.view 'editor'


app.route
    method: 'GET'
    path: '/static/{param*}'
    handler:
        directory:
            path: 'public'

app.ro

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