
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

    delayedTrigger: (object, delayedEvent, delay) ->
        start = @getTime()
        id = start + delayedEvent
        count = 1
        waitTime = delay/Math.pow(2,count)
        delayedTime = waitTime

        wait = ->
            if @getElapsedTime(start) >= delay
                object.trigger delayedEvent
            else
                count++
                diff = (delayedTime - @getElapsedTime(start))
                waitTime = delay/Math.pow(2,count)
                delayedTime += waitTime
                @delayCache[id] = setTimeout wait, waitTime - diff

        delayCache[id] = setTimeout wait, waitTime


module.exports =
    Clock: Clock