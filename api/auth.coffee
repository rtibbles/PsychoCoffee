boom = require 'boom'
_ = require 'underscore'
bcrypt = require 'bcrypt'
mongodb = require 'mongodb'
dataconfig = require './dataconfig'
User = require './models/User'

config = (handler, mode) ->
    handler: handler
    auth:
        mode: mode
        strategy: 'session'
    plugins:
        'hapi-auth-cookie':
            redirectTo: false

validate = (email, password, callback) ->

    User.findOne "email": email, (err, user) ->
        if err
            reply boom.badRequest(err)
        if user?
            bcrypt.compare password, user.password, (err, isValid) ->
                callback err, isValid, user
        else
            return callback(null, false)

login = (request, reply) ->
    if request.auth.isAuthenticated
        return reply
            user: _.omit(request.auth.credentials,
                ['password', 'auth_token'])
    email = request.payload.email
    password = request.payload.password
    validate email, password, (err, isValid, user) ->
        if err
            reply boom.badRequest(err)
        else if isValid
            request.auth.session.set user
            reply user: _.omit(user, ['password'])
        else
            reply boom.badRequest("User not found")

checkAuth = (request, reply) ->
    if not request.auth.isAuthenticated
        return reply boom.unauthorized("Not authorized")
    user_id = request.auth.credentials._id

    User.findById user_id, (err, user) ->
        if user?
            reply user: _.omit(user, ['password'])
        else
            reply boom.badRequest("Client has no valid login cookies.")


register = (server) ->

    server.register require('hapi-auth-cookie'), (err) ->

        server.auth.strategy 'session', 'cookie',
            password: dataconfig.session.password
            cookie: dataconfig.session.cookie
            ttl: 1000000
            keepAlive: true
            isSecure: false

    server.route
        method: 'GET'
        path: '/api/auth'
        config: config(checkAuth, 'try')

    server.route
        method: 'POST'
        path: '/api/auth/login'
        config: config(login, 'try')

module.exports =
    register: register
    config: config