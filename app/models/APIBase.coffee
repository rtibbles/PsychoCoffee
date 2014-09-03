'use strict'

define ->

    class Model extends Backbone.AssociatedModel


    class Collection extends Backbone.Collection

        urlBase: "/api/"
        model: Model

        initialize: (options={}) ->
            @params = {}
            for apiFilter in @apiFilters
                filterparam = "filter[where][#{apiFilter}]"
                if options[apiFilter]?
                    @params[filterparam] = options[apiFilter]

        filterFetch: (options={}) ->
            options.data = @params
            @fetch options

        url: =>
            @urlBase + @apiCollection

    Model: Model
    Collection: Collection
