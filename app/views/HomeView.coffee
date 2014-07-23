'use strict'

template = require '../templates/home'
View = require './View'

module.exports = class HomeView extends View
    id: 'home-view'
    template: template