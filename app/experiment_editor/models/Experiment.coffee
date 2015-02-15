'use strict'

module.exports = class Collection extends Backbone.Collection

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