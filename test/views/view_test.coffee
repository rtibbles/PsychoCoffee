module "View Baseclass Tests",

    setup: ->
        window.view = new PsychoCoffee.View

test "Default values", ->
    expect 3

    equal window.view.clock, undefined
    equal window.view.user_id, undefined
    equal window.view.injectedParameters, undefined

test "Methods", ->
    expect 4
    
    equal window.view.template(), undefined
    deepEqual window.view.getRenderData(), {}
    deepEqual window.view.render(), window.view
    equal window.view.afterRender(), undefined