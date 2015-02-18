mongoModels = require 'hapi-mongo-models'
objectAssign = require 'object-assign'
_ = require 'underscore'
boom = require 'boom'

allAuthMethods = ["create", "get", "findObjects", "updateObject", "del"]

authWrapper = (method) ->
    (request, reply) ->
        method request, reply, uId: request.auth?.credentials?._id || false

modelGenerator = (collection, authMethods=[], filterFields=[]) ->

    class Model extends mongoModels.BaseModel
        constructor: (attrs) ->
            objectAssign @, attrs

    Model._collection = collection

    Model.filterFields = filterFields

    Model.payload = (request) ->
        if request.method == 'get'
            request.query
        else
            request.payload

    Model.filter = (result) ->
        if _.isArray(result)
            for i, item of result
                if Model.filterFields.length > 0
                    result[i] = _.pick item, Model.filterFields
                else
                    result[i] = _.omit item, ["uId"]
        else
            if Model.filterFields.length > 0
                result = _.pick result, Model.filterFields
            else
                result = _.omit result, ["uId"]
        return result

    Model.handleResponse = (err, result, reply) ->
        if err
            reply err
        else if _.isEmpty(result)
            plural = if _.isArray(result) then "s" else ""
            reply boom.notFound("Item#{plural} not found")
        else
            result = Model.filter(result)
            reply result

    Model.create = (request, reply, payload={}) ->
        payload = objectAssign Model.payload(request), payload
        Model.insert payload, (err, result) ->
            Model.handleResponse(err, result, reply)

    Model.get = (request, reply, payload={}) ->
        payload._id = Model.ObjectId request.params.id
        Model.findOne payload, (err, result) ->
            Model.handleResponse(err, result, reply)

    Model.findObjects = (request, reply, payload={}) ->
        payload = objectAssign Model.payload(request), payload
        if _.isEmpty request.query
            Model.find payload, (err, result) ->
                Model.handleResponse(err, result, reply)
        else
            pagedFields = ["fields", "sort", "limit", "page"]
            for key, value of request.query
                if key not in pagedFields
                    payload[key] = value
            Model.pagedFind(
                payload,
                request.query.fields,
                request.query.sort,
                request.query.limit,
                request.query.page,
                (err, result) ->
                    data = result.data
                    data["_pages"] = result.pages
                    data["_items"] = result.items
                    Model.handleResponse(err,
                        data, reply)
                )

    Model.updateObject = (request, reply, payload={}) ->
        query = {}
        query._id = Model.ObjectId request.params.id
        if payload.uId?
            query.uId = payload.uId
        payload = objectAssign Model.payload(request), payload
        delete payload._id
        Model.update query, payload, {fullResult: true}, (err, result) ->
            if _.isEmpty(result) and query.uId?
                return reply(
                    boom.forbidden(
                        "You do not have permission to update this resource."))
            Model.handleResponse(err, result, reply)

    Model.del = (request, reply, payload={}) ->
        query = {}
        query._id = Model.ObjectId request.params.id
        if payload.uId?
            query.uId = payload.uId
        Model.remove query, {}, (err, result) ->
            if result == 0 and query.uId?
                reply(
                    boom.forbidden(
                        "You do not have permission to delete this resource."))
            result = if result == 0 then 0 else {count: result}
            Model.handleResponse(err, result, reply)

    authMethods = if authMethods == "all" then allAuthMethods else authMethods

    for method in authMethods
        Model[method] = authWrapper(Model[method])

    Model.authMethods = authMethods

    return Model

module.exports = modelGenerator