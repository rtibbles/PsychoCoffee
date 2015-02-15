'use strict'

User = require './User'

# Modified from https://github.com/alexanderscott/backbone-login

module.exports = class Session extends Backbone.Model

    remote: true

    defaults:
        logged_in: false
        user_id: ''

    initialize: ->
        @user = new User


    url: ->
        return PsychoEdit.API + '/auth'

    updateSessionUser: (userData) ->
        @user.set(_.omit(userData, ["password"]))


    checkAuth: (callback, args) ->
        @fetch(
            success: (mod, res) =>
                if not res.error? and res.user?
                    @updateSessionUser(res.user)
                    @set({ user_id: @user.id, logged_in: true })
                    if 'success' of callback then callback.success(mod, res)
                else
                    @set({ logged_in : false })
                    if 'error' of callback then callback.error(mod, res)
            error: (mod, res) =>
                @set({ logged_in : false })
                if 'error' of callback then callback.error(mod, res)
        ).complete ->
            if 'complete' of callback then callback.complete()

    postAuth: (opts, callback, args) ->
        postData = _.omit(opts, 'method')
        $.ajax(
            url: @url() + '/' + opts.method
            contentType: 'application/json'
            dataType: 'json'
            type: 'POST'
            data:  JSON.stringify _.omit(opts, 'method')
            success: (res) =>
                if not res.error?
                    if opts.method in['login', 'signup']

                        @updateSessionUser( res.user || {} )
                        @set({ user_id: @user.id, logged_in: true })
                    else
                        @set({ logged_in: false })

                    if callback? and 'success' of callback
                        callback.success(res)
                else
                    if callback? and 'error' of callback
                        callback.error(res)
            error: (mod, res) ->
                if callback? and 'error' of callback
                    callback.error(res)
        ).complete (res) ->
            if callback? and 'complete' of callback
                callback.complete(res)

    login: (opts, callback, args) ->
        @postAuth(_.extend(opts, { method: 'login' }), callback)

    logout: (opts, callback, args) ->
        @postAuth(_.extend(opts, { method: 'logout' }), callback)

    signup: (opts, callback, args) ->
        @postAuth(_.extend(opts, { method: 'signup' }), callback)

    removeAccount: (opts, callback, args) ->
        @postAuth(_.extend(opts, { method: 'remove_account' }), callback)
