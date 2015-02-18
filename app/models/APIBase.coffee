'use strict'

class Model extends Backbone.AssociatedModel


class Collection extends Backbone.Collection

    urlBase: "/api/"
    model: Model

    initialize: (options={}) ->
        @params = {}
        for apiFilter in @apiFilters
            if options[apiFilter]?
                @params[apiFilter] = options[apiFilter]

    filterFetch: (options={}) ->
        options.data = @params
        @fetch options

    url: =>
        @urlBase + @apiCollection

module.exports =
    Model: Model
    Collection: Collection
