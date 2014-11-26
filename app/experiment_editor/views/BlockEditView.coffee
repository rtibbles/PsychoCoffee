'use strict'

CodeGeneratorView = require './CodeGeneratorView'
Template = require '../templates/blockedit'
TrialObjectModelEditView = require './TrialObjectModelEditView'

module.exports = class BlockEditView extends CodeGeneratorView
    template: Template

    events:
        "click .addtrialobject": "addTrialObject"
        "click .trialobject": "editTrialObjectModel"

    getRenderData: ->
        attributes = _.clone(@model?.attributes or {})
        return _.extend attributes,
            trialObjects: PsychoEdit.trialObjects

    addTrialObject: (event) ->
        type = event.target.id
        newTrialObject = @model.get("trialObjects").add({type: type})
        modelEditView = new TrialObjectModelEditView({model: newTrialObject})
        modelEditView.render()
        modelEditView.appendTo("#overlay")

    editTrialObject: (event) ->
        trialobjectmodel = @model.get("blocks").get(event.target.id)
        editView = new TrialObjectModelEditView({model: trialobjectmodel})
        editView.appendTo("#overlay")