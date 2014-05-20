
# Initialize performance.now to always return a time, regardless of browser.
window.performance = window.performance or {}
performance.now =
        performance.now    or
        performance.mozNow    or
        performance.msNow     or
        performance.oNow      or
        performance.webkitNow or
        -> return new Date().getTime()

performance.type =
    if performance.now or
        performance.mozNow or
        performance.msNow or
        performance.oNow or
        performance.webkitNow
        then "html5"
    else
        "date"

class Clock
    constructor: ->
        # Set time that clock was initialized
        @reset()
        @delayCache = {}

    reset: ->
        @start = performance.now()

    getTime: ->
        performance.now() - @start

    getElapsedTime: (time) ->
        @getTime() - time

    getAbsoluteTime: ->
        new Date().getTime()

    setStartTime: (time) ->
        @start = Number(time)

    delayedTrigger: (callback, delay, power=2) ->
        start = @getTime()
        id = start + callback.toString()
        count = 1
        waitTime = delay/Math.pow(power,count)
        delayedTime = waitTime

        wait = =>
            if @getElapsedTime(start) >= delay
                callback()
            else
                count++
                diff = (@getElapsedTime(start) - delayedTime)
                waitTime = delay/Math.pow(power,count)
                delayedTime += waitTime
                @delayCache[id] = setTimeout wait, waitTime - diff

        @delayCache[id] = setTimeout wait, waitTime
        return id

    clearEvent: (id) ->
        clearTimeout(@delayCache[id])

    clearAllEvents: ->
        _.each @delayCache, (value, key, list) -> clearTimeout(value)


module.exports =
    Clock: Clock