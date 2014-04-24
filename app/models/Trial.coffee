'use strict'

module.exports = App.Trial = DS.Model.extend
    experiment: DS.belongsTo 'experiment',
        inverse: 'trial'
    timer: DS.belongsTo 'timer'
    trialobjects: DS.hasMany 'trialObject', polymorphic: true, async: true