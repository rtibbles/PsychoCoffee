
# Initialize performance.now to always return a time, regardless of browser.
window.performance = window.performance or {}

performance.type =
    if performance.now or
        performance.mozNow or
        performance.msNow or
        performance.oNow or
        performance.webkitNow
        then "html5"
    else
        "date"

performance.now =
        performance.now    or
        performance.mozNow    or
        performance.msNow     or
        performance.oNow      or
        performance.webkitNow or
        -> return new Date().getTime()

# Enable the passage of the 'this' object through the JavaScript timers
 
__nativeST__ = window.setTimeout
__nativeSI__ = window.setInterval

window.setTimeout = (vCallback, nDelay, aArgs...) ->
    oThis = this
    if vCallback instanceof Function
        callback = -> vCallback.apply(oThis, aArgs)
    else
        callback = vCallback
    __nativeST__(callback, nDelay)
 
window.setInterval = (vCallback, nDelay, aArgs...) ->
    oThis = this
    if vCallback instanceof Function
        callback = -> vCallback.apply(oThis, aArgs)
    else
        callback = vCallback
    __nativeSI__(callback, nDelay)

# http://paulirish.com/2011/requestanimationframe-for-smart-animating/
# http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating
 
# requestAnimationFrame polyfill by Erik Möller
# fixes from Paul Irish and Tino Zijdel
 
lastTime = 0
vendors = ['ms', 'moz', 'webkit', 'o']
for vendor in vendors
    if window.requestAnimationFrame
        window.AnimationFrameType = "RequestAnimationFrame"
        break
    window.requestAnimationFrame = window[vendor + 'RequestAnimationFrame']
    window.cancelAnimationFrame =
        window[vendor + 'CancelAnimationFrame'] or
        window[vendors + 'CancelRequestAnimationFrame']


if not window.requestAnimationFrame
    window.AnimationFrameType = "SetTimeout"
    window.requestAnimationFrame = (callback, element) ->
        currTime = performance.now()
        timeToCall = Math.max(0, 16 - (currTime - lastTime))
        id = window.setTimeout(
            -> callback(currTime + timeToCall),
            timeToCall
            )
        lastTime = currTime + timeToCall
        return id

if not window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
        clearTimeout(id)

class Clock
    constructor: (framerate=60) ->
        _.extend @, Backbone.Events
        # Set time that clock was initialized
        @reset()
        @tick = 1000/framerate
        @frame = 0
        @changeEvents = []
        @timingType = performance.type
        @animationFrameType = window.AnimationFrameType
        console.log "Using clock type:", @timingType

    reset: =>
        @start = performance.now()

    getTime: =>
        performance.now() - @start

    getElapsedTime: (time) =>
        @getTime() - time

    getAbsoluteTime: ->
        new Date().getTime()

    setStartTime: (time) =>
        @start = Number(time)

    delayedTrigger: (delay, object, callback) =>
        frames = delay/@tick
        nearestFrame = Math.floor frames
        # Can't guarantee precision below 16ms, so don't even try.
        object.listenToOnce(@, @frame + nearestFrame, callback)

    startTimer: =>
        @timerStart = @getTime()
        @ticktock()

    pauseTimer: =>
        @pauseTimestamp = @getTime()
        @stopTimer()
        if window.confirm("Do you really want to stop the experiment?")
            window.close()
        else
            @resumeTimer(@pauseTimestamp)

    resumeTimer: (timestamp) =>
        @start += @getTime() - timestamp
        @ticktock()

    stopTimer: =>
        clearTimeout @timer
        @frame = 0
        delete @timerStart

    timerElapsed: =>
        @getElapsedTime(@timerStart) or 0

    ticktock: =>
        # console.log @timerElapsed()
        @timer = setTimeout(
            @ticktock,
            @tick - (@timerElapsed() - @frame*@tick)
            )
        @trigger(@frame)
        # console.log "Tick Tock!", @timerElapsed() - @frame*@tick
        @frame += 1
        # if @frame > 100 then @stopTimer()
        if @changeEvents.length then @canvas?.renderAll()
        @changeEvents = []


module.exports =
    Clock: Clock