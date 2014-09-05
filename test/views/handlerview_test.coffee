module "HandlerView Baseclass Tests",

    setup: ->
        @view = new PsychoCoffee.HandlerView
        @model = new PsychoCoffee.Base.Model
        @datamodel = new PsychoCoffee.ExperimentDataHandler.Model
        @view.model = @model
        @view.datamodel = @datamodel
        @datamodellogstub = sinon.stub @datamodel, "logEvent"
        @modelnamestub = sinon.stub @model, "name", -> ""
        


test "Methods", ->
    expect 2
    
    @view.logEvent("test")

    ok @datamodellogstub.calledOnce
    ok @modelnamestub.calledOnce
