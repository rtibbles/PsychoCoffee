'use strict'

class Model extends PsychoCoffee.Experiment.Model

    remote: true

    parse: (response) ->
        if _.isArray response
            response = response[0]
        return response

    urlRoot: ->
        PsychoEdit.API + "/experiments"

class Collection extends Backbone.Collection

    remote: true

    url: ->
        PsychoEdit.API + "/experiments"

    model: Model
    apiFilters: ["id", "title"]

    initialize: (options={}) ->
        @params = {}
        for apiFilter in @apiFilters
            filterparam = "filter[fields][#{apiFilter}]"
            @params[filterparam] = true

    filterFetch: (options={}) ->
        options.data = @params
        @fetch options

module.exports =
    Collection: Collection
    Model: Model