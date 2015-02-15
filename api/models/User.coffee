Base = require './Base'
Joi = require 'joi'
boom = require 'boom'
bcrypt = require 'bcrypt'

User = Base('users', ['get', 'findObjects', 'updateObject', 'del'], ['email', '_id'])

User.schema = Joi.object().keys
    name: Joi.string().required()
    password: Joi.string().required()

User.create = (request, reply, payload={}) ->
    payload = objectAssign Model.payload(request), payload
    User.validate payload, (err, value) ->
        if err
            return reply boom.badRequest error: err
        bcrypt.genSalt 10, (err, salt) ->
            if err
                return reply boom.badImplementation(err)
            else
                bcrypt.hashSync value.password, salt, (err, hash) ->
                    if err
                        return reply boom.badImplementation(err)
                    else
                        value.password = hash
                        Model.insert value, (err, result) ->
                            Model.handleResponse(err, result, reply)

module.exports = User