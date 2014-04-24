'use strict'

module.exports = App.Timer = DS.Model.extend
    trial: DS.belongsTo 'trial',
        inverse: 'timer'

