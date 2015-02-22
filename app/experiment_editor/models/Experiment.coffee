'use strict'

class Model extends PsychoCoffee.Experiment.Model

    remote: true

    urlRoot: ->
        PsychoEdit.API + "/experiments"

class Collection extends Backbone.Collection

    remote: true

    url: ->
        PsychoEdit.API + "/experiments"

    model: PsychoCoffee.Experiment.Model
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