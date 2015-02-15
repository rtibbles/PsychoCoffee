Base = require './Base'
Joi = require 'joi'
boom = require 'boom'
objectAssign = require 'object-assign'
bcrypt = require 'bcrypt'
nodemailer = require 'nodemailer'
dataconfig = require '../dataconfig'
uuid = require 'node-uuid'
_ = require 'underscore'

transporter = nodemailer.createTransport
    service: dataconfig.email.service
    auth: dataconfig.email.auth
    host: dataconfig.email.host

User = Base('users', ['get', 'findObjects', 'updateObject', 'del'], ['email', '_id'])

User.schema = Joi.object().keys
    email: Joi.string().required()
    password: Joi.string().required()

sendVerificationEmail = (result, callback) ->
    activation_id = uuid.v1()
    if _.isArray(result)
        result = result[0]
    result["activation_id"] = activation_id
    id = result._id
    delete result._id
    User.findByIdAndUpdate id, result, (err, result) ->
        mailOptions =
            to: result.email
            subject: "Please confirm your email address"
            from: "#{ dataconfig.email.sender.name }, <#{dataconfig.email.sender.address}>"
            text: """
            Please copy the following link into your browser:
            http:/psyc.io/validate?id=#{ result.activation_id }
            This will activate your account for use.
            Regards,
            #{ dataconfig.email.sender.name }
            """
            html: """
            Please click the following link:
            <a href="http:/psyc.io/validate?id=#{ result.activation_id }">Activate account</a>
            This will activate your account for use.
            Regards,
            #{ dataconfig.email.sender.name }
            """
        transporter.sendMail mailOptions, (err, info) ->
            if err
                callback(err, info)
            else
                callback(err, result)

User.create = (request, reply, payload={}) ->
    payload = objectAssign User.payload(request), payload
    User.validate payload, (err, value) ->
        if err
            return reply boom.badRequest error: err
        User.findOne email: value.result, (err, result) ->
            if not _.isEmpty(result)
                return reply boom.unauthorized("User already exists")
            bcrypt.genSalt 10, (err, salt) ->
                if err
                    return reply boom.badImplementation(err)
                bcrypt.hash value.password, salt, (err, hash) ->
                    if err
                        return reply boom.badImplementation(err)
                    value.password = hash
                    value.active = false
                    User.insert value, (err, result) ->
                        sendVerificationEmail result, (err, result) ->
                            User.handleResponse(err, result, reply)

module.exports = User