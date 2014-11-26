'use strict'

generator = require "../utils/trialObjectKind_generator"
ExperimentEditView = require '../views/ExperimentEditView'

# The application bootstrapper.
PsychoEdit =
    initialize: ->
        @trialObjects = generator()
        @editView = new ExperimentEditView
        @editView.render()
        @editView.appendTo("#editor_window")


module.exports = PsychoEdit