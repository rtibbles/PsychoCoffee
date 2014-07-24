homeView = require("../views/HomeView")
experimentView = require("../views/ExperimentView")

module.exports = class Router extends Backbone.Router
    routes:
        'experiment/:experiment': 'experiment'
        '': 'home'

    home: ->
        @loadView new homeView

    experiment: (experiment) ->
        @loadView new experimentView experiment: experiment

    loadView: (view) ->
        if @view
            if @view.close then @view.close() else @view.remove()
        @view = view
        @view.appendTo("#app")
        @view.render()