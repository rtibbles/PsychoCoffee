'use strict'

module.exports = class TrialModel extends Backbone.Model
    # experiment: DS.belongsTo 'experiment',
    #     inverse: 'trial'
    # trialobjects: DS.hasMany 'trialObject', polymorphic: true, async: true
    # width: DS.attr 'number'
    # height: DS.attr 'number'

TrialModel.Data = [
    {
     id: 1
     experiment: 1
     width: 800
     height: 600
     trialobjects: [1]
    }
]