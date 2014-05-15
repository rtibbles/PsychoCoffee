'use strict'

module.exports = App.Trial = DS.Model.extend
    experiment: DS.belongsTo 'experiment',
        inverse: 'trial'
    trialobjects: DS.hasMany 'trialObject', polymorphic: true, async: true
    width: DS.attr 'number'
    height: DS.attr 'number'