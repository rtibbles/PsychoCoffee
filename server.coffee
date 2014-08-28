loopback = require 'loopback'
boot = require 'loopback-boot'
path = require 'path'

api = require './api/api'

app = loopback()

# Set up the /favicon.ico
app.use loopback.favicon()

# request pre-processing middleware
app.use loopback.compress()

# -- Add your pre-processing middleware here --

# boot scripts mount components like REST API
api app
# -- Mount static files here--
# All static middleware should be registered at the end, as all requests
# passing the static middleware are hitting the file system
# Example:
#   app.use(loopback.static(path.resolve(__dirname', '../client')));

app.use loopback.static path.join __dirname, 'public'

# Requests that get this far won't be handled
# by any middleware. Convert them into a 404 error
# that will be handled later down the chain.
app.use loopback.urlNotFound()

# The ultimate error handler.
app.use loopback.errorHandler()

app.start = ->
    # start the web server
    app.listen ->
        app.emit('started');
        console.log('Web server listening at: %s', app.get('url'));

exports.startServer = (port, path, callback) ->
    app.start()

if require.main == module
    app.start()