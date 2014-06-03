
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

class Clock
    constructor: ->
        # Set time that clock was initialized
        @reset()
        console.log "Using clock type:", performance.type
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

    delayedTrigger: (callback, delay, delay_func) ->
        if delay_func == "emb" then timeOut = Ember.run.later else timeOut = setTimeout
        start = @getTime()
        id = start + callback.toString()
        count = 1
        waitTime = delay #Math.min(10, delay)
        delayedTime = waitTime

        wait = =>
            remaining = @getElapsedTime(start) - delay
            if remaining >= 0
                callback(remaining)
            else
                count++
                diff = (remaining + delay - delayedTime)
                waitTime = Math.min(10, remaining)
                delayedTime += waitTime
                @delayCache[id] = timeOut wait, waitTime - diff

        @delayCache[id] = timeOut wait, waitTime
        return id

    clearEvent: (id) ->
        clearTimeout(@delayCache[id])

    clearAllEvents: ->
        _.each @delayCache, (value, key, list) -> clearTimeout(value)


module.exports =
    Clock: Clock