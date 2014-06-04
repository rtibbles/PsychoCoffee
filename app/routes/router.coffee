application = require '../app/app'

module.exports = class Router extends Backbone.Router
  routes:
    '': 'home'

  home: ->
    $('#app').html application.homeView.render().el