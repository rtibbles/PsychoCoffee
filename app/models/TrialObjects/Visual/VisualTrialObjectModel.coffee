'use strict'

TrialObjectModel = require("../../TrialObjectModel")

module.exports = class VisualTrialObjectModel extends TrialObjectModel
    # x: DS.attr 'number'
    # y: DS.attr 'number'
    # width: DS.attr 'number'
    # height: DS.attr 'number'
    # opacity: DS.attr 'number'

# Required for Backbone Relational models extended using Coffeescript syntax
# VisualTrialObjectModel.setup()