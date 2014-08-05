homeView = require("../views/HomeView")
experimentView = require("../views/ExperimentView")

module.exports = class Router extends Backbone.Router
    routes:
        '': 'home'

    home: ->
        #@loadView new homeView
        return true

    loadView: (view) ->
        if @view
            if @view.close then @view.close() else @view.remove()
        @view = view
        @view.appendTo("#app")
        @view.render()