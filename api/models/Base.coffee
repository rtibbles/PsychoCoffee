mongoModels = require 'hapi-mongo-models'
objectAssign = require 'object-assign'
_ = require 'underscore'
boom = require 'boom'

module.exports = modelGenerator = (collection) ->

    class Model extends mongoModels.BaseModel
        constructor: (attrs) ->
            objectAssign @, attrs

    Model._collection = collection

    Model.payload = (request) ->
        if request.method == 'get'
            request.query
        else
            request.payload

    Model.handleResponse = (err, result, reply) ->
        if err
            reply err
        else if _.isEmpty(result)
            plural = if _.isArray(result) then "s" else ""
            reply boom.notFound("Item#{plural} not found")
        else
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
        if _.isEmpty request.params
            Model.find payload, (err, result) ->
                Model.handleResponse(err, result, reply)
        else
            Model.pagedFind(
                payload,
                request.params.fields,
                request.params.sort,
                request.params.limit,
                request.params.page,
                (err, result) ->
                    data = result.data
                    data["_pages"] = result.pages
                    data["_items"] = result.items
                    Model.handleResponse(err, data, reply)
                )

    Model.updateObject = (request, reply, payload={}) ->
        query = {}
        query._id = Model.ObjectId request.params.id
        if payload.uId?
            query.uId = payload.uId
        payload = objectAssign Model.payload(request), payload
        Model.update query, payload, {}, (err, result) ->
            if _.isEmpty(result) and query.uId?
                reply(boom.forbidden("You do not have permission to update this resource."))
            Model.handleResponse(err, result, reply)

    Model.del = (request, reply, payload={}) ->
        query = {}
        query._id = Model.ObjectId request.params.id
        if payload.uId?
            query.uId = payload.uId
        payload = objectAssign Model.payload(request), payload
        Model.remove query, {}, (err, result) ->
            if result == 0 and query.uId?
                reply(boom.forbidden("You do not have permission to delete this resource."))
            result = if result == 0 then 0 else {count: result}
            Model.handleResponse(err, result, reply)

    return Model