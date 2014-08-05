
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


class Clock
    constructor: (tick=20) ->
        _.extend @, Backbone.Events
        # Set time that clock was initialized
        @reset()
        @tick = tick
        @clock_type = performance.type
        console.log "Using clock type:", performance.type

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
        timeoutDelay = @tick * (nearestFrame - frames)
        if timeoutDelay >= 1
            callback = -> setTimeout(callback, timeoutDelay)
        object.listenToOnce(@, @count + nearestFrame, callback)

    startTimer: =>
        @count = 0
        @timerStart = @getTime()
        @ticktock()

    timerElapsed: =>
        @getElapsedTime(@timerStart)

    ticktock: =>
        @trigger(@count)
        setTimeout(@ticktock, @tick + (@timerElapsed() - @count*@tick))
        @count += 1
        # console.log "Tick Tock!", @getTime() - @count*@tick


module.exports =
    Clock: Clock