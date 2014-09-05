module "Clock Util Tests",

    setup: ->
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

framerateTests = (framerate) ->
    window.clock = new PsychoCoffee.clock.Clock(framerate)

    startTimes = [1..framerate]

    expect framerate + 2

    timedCheck = (frame, startTime) ->
        clocktime = window.clock.timerElapsed() - startTime
        frametime = frame*window.clock.tick
        ok Math.abs(clocktime - frametime) < window.clock.tick

    window.clock.startTimer()
    ok typeof(window.clock.timerStart) == "number"

    window.clock.stopTimer()
    ok window.clock.timerStart == undefined

    stop()
    window.clock.startTimer()
    [1..framerate].forEach (i) ->
        startTimes[i-1] = window.clock.timerElapsed()
        setTimeout ->
            timedCheck(i, startTimes[i-1])
        , i*window.clock.tick
    
    setTimeout ->
        start()
    , 1500


test "Timer Tick Tock Test", ->
    ###
    Runs 60 frames (a second under default frame rate) of the timer
    and checks that the total time elapsed is within acceptable limits (16.7ms).
    ###
    framerateTests(60)
