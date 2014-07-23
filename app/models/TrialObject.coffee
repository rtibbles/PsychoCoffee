'use strict'

nestedModules = require '../utils/nestedModules'

Base = require('./Base')

subModels = {}
for modulename in nestedModules('models/TrialObjects')
    subModels[modulename.toLowerCase()] = modulename + ".Model"

class Model extends Base.Model
    subModelTypes: subModels
    # delay: DS.attr 'number'
    # duration: DS.attr 'number'

# Required for Backbone Relational models extended using Coffeescript syntax
Model.setup()

class Collection extends Base.Collection


module.exports =
    Model: Model
    Collection: Collection