'use strict'

module.exports = App.TrialObject = DS.Model.extend
    trial: DS.belongsTo 'trial',
        inverse: 'trialObjects'
    delay: DS.attr 'number'
    duration: DS.attr 'number'
    triggers: DS.hasMany 'trigger'