'use strict'

nestedImport = require '../utils/nestedImport'
Model = require './Model'
subModels = {}
for modulename in nestedImport('models/TrialObjects')
    subModels[modulename.toLowerCase()] = modulename

module.exports = class TrialObjectModel extends Model
    subModelTypes: subModels
    # delay: DS.attr 'number'
    # duration: DS.attr 'number'

# Required for Backbone Relational models extended using Coffeescript syntax
TrialObjectModel.setup()