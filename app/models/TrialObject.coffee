'use strict'

module.exports = App.TrialObject = DS.Model.extend
    trial: DS.belongsTo 'trial',
        inverse: 'trialObjects'

