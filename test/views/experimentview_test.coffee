module "Experiment View Tests",

    setupExperimentModel: ->
        @experimentmodel = new PsychoCoffee.Experiment.Model
        @experimentmodelgetstub = sinon.stub(@experimentmodel, "get")
        @experimentmodelgetstub.withArgs("identifier").returns("test_id")
        @experimentmodelgetstub.withArgs("saveInterval").returns(10000)
        @experimentmodelgetstub.withArgs("blocks")
            .returns(new Backbone.Collection())
        @experimentmodelgetstub.withArgs("files")
            .returns(new PsychoCoffee.File.Collection())
        @experimentmodelparamstub =
            sinon.stub(@experimentmodel, "returnParameters", -> {})

    setupExperimentView: ->
        @experimentview =
            new PsychoCoffee.ExperimentView(model: @experimentmodel)

    setup: ->
        @server = sinon.fakeServer.create()
        @server.respondWith(
            /.*/
            [
              200
              {"Content-Type": "application/json"}
              '[]'
            ]
        )
        @setupExperimentModel()
        @setupExperimentView()

    tearDown: ->
        @server.restore()
        @experimentmodelgetstub.restore()
        @experimentmodelparamstub.restore()

test "Default values", ->

    expect 5

    
    @server.respond()
    @experimentview.startExperiment()
    ok @experimentview.clock instanceof PsychoCoffee.clock.Clock,
        "Check clock instantiated"
    equal @experimentview.user_id,
        PsychoCoffee.stringHash(PsychoCoffee.fingerprint()),
        "Check user_id instantiated"
    ok @experimentview.datacollection instanceof
        PsychoCoffee.ExperimentDataHandler.Collection,
        "Check data collection instantiated"
    ok @experimentview.datamodel instanceof
        PsychoCoffee.ExperimentDataHandler.Model,
        "Check data model instantiated"
    equal @server.requests.length, 2

test "Methods", ->

    expect 5

    @preloadExperiment =
        sinon.stub @experimentview, "preLoadExperiment"

    @server.respond()

    ok @preloadExperiment.calledOnce

    @logEvent = sinon.stub @experimentview, "logEvent"

    @endExperiment = sinon.stub @experimentview, "endExperiment"

    @experimentview.startExperiment()

    ok @logEvent.calledOnce

    ok @endExperiment.calledOnce

    @endExperiment.restore()

    @experimentview.endExperiment()

    ok @logEvent.calledTwice

    time = @experimentview.time

    @experimentview.refreshTime()

    notEqual time, @experimentview.time
