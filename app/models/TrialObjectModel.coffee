'use strict'

nestedImport = require '../utils/nestedImport'
Model = require './Model'
subModels = {}
subModels[modulename.toLowerCase()] = modulename for modulename in nestedImport('models/TrialObjects')

module.exports = class TrialObjectModel extends Model
    subModelTypes: subModels
    # delay: DS.attr 'number'
    # duration: DS.attr 'number'

# Required for Backbone Relational models extended using Coffeescript syntax
TrialObjectModel.setup()