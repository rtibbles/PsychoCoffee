module "View Baseclass Tests",

    setup: ->
        @view = new PsychoCoffee.View

test "Default values", ->
    expect 3

    equal @view.clock, undefined
    equal @view.user_id, undefined
    equal @view.injectedParameters, undefined

test "Methods", ->
    expect 4
    
    equal @view.template(), undefined
    deepEqual @view.getRenderData(), {}
    deepEqual @view.render(), @view
    equal @view.afterRender(), undefined