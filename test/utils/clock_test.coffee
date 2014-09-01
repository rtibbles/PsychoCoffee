module "Clock Util Tests",

    setup: =>
        window.clock = new PsychoCoffee.clock.Clock()

test "Default values", ->
    expect 6

    equal window.clock.tick, 1000/60
    equal window.clock.frame, 0
    deepEqual window.clock.changeEvents, []
    ok typeof(window.clock.timingType) == "string"
    ok typeof(window.clock.animationFrameType) == "string"
    ok typeof(window.clock.start) == "number"

test "Clock Time Methods", ->
    expect 6

    stop()

    setTimeout ->
        oldStart = window.clock.start
        window.clock.reset()
        ok window.clock.start > oldStart

        timenow3 = window.clock.getTime()
        window.clock.setStartTime(0)
        ok timenow3 < window.clock.getTime()

        ok typeof(window.clock.getTime()) == "number"
        ok window.clock.getTime() > 0

        timenow1 = window.clock.getTime()
        stop()
        setTimeout ->
            ok window.clock.getElapsedTime(timenow1) > 0
            start()
        , 100

        timenow2 = new Date().getTime()
        stop()
        setTimeout ->
            ok window.clock.getAbsoluteTime() > timenow2
            start()
        , 100

        start()
    , 100

    # TODO: Tests for stopWatch/Trial Timing methods.
