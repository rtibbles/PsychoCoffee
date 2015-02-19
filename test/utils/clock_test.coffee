module "Clock Util Tests",

    setup: ->
        @clock = new PsychoCoffee.clock.Clock()

test "Default values", ->
    expect 6

    equal @clock.tick, 1000/60
    equal @clock.frame, 0
    deepEqual @clock.changeEvents, []
    ok typeof(@clock.timingType) == "string"
    ok typeof(@clock.animationFrameType) == "string"
    ok typeof(@clock.start) == "number"

test "Clock Time Methods", ->
    expect 6

    stop()

    setTimeout =>
        oldStart = @clock.start
        @clock.reset()
        ok @clock.start > oldStart

        timenow3 = @clock.getTime()
        @clock.setStartTime(0)
        ok timenow3 < @clock.getTime()

        ok typeof(@clock.getTime()) == "number"
        ok @clock.getTime() > 0

        timenow1 = @clock.getTime()
        stop()
        setTimeout =>
            ok @clock.getElapsedTime(timenow1) > 0
            start()
        , 100

        timenow2 = new Date().getTime()
        stop()
        setTimeout =>
            ok @clock.getAbsoluteTime() > timenow2
            start()
        , 100

        start()
    , 100

framerateTests = (framerate) ->
    @clock = new PsychoCoffee.clock.Clock(framerate)

    startTimes = [1..framerate]

    expect framerate + 2

    timedCheck = (frame, startTime) =>
        clocktime = @clock.timerElapsed() - startTime
        frametime = frame*@clock.tick
        ok Math.abs(clocktime - frametime) < @clock.tick,
            "Failed tolerances on frame #{frame}"

    @clock.startTimer()
    ok typeof(@clock.timerStart) == "number"

    @clock.stopTimer()
    ok @clock.timerStart == undefined

    stop()
    @clock.startTimer()
    [1..framerate].forEach (i) =>
        startTimes[i-1] = @clock.timerElapsed()
        setTimeout ->
            timedCheck(i, startTimes[i-1])
        , i*@clock.tick
    
    setTimeout ->
        start()
    , 1500


test "Timer Tick Tock Test", ->
    ###
    Runs 60 frames (a second under default frame rate) of the timer
    and checks that the total time elapsed is within acceptable limits (16.7ms).
    ###
    framerateTests(60)
