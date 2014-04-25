'use strict'

module.exports = App.Trigger = DS.Model.extend
    source: DS.belongsTo "trialObject", polymorphic: true, async: true
    target: DS.belongsTo "trialObject", polymorphic: true, async: true
    event: DS.attr "string"
