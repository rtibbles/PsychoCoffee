Base = require './Base'
DiffTools = require '../../app/utils/diff'

ExperimentDataHandler = Base('experimentdatahandlers', ['findObjects', 'del'])

ExperimentDataHandler.patch = (request, reply) ->
    resource_id = request.params.id
    if request.method == 'get'
        payload = request.query
    else
        payload = request.payload
    @findById resource_id, (err, doc) ->
        if err
            reply err
        else
            update = DiffTools.Merge(doc, payload)
            @findByIdAndUpdate resource_id, update, {}, (err, doc) ->
                if not err?
                    return reply
                        error:null
                        message:'Updated successfully'
                        patched: true

module.exports = ExperimentDataHandler