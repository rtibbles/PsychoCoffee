
# Initialize performance.now to always return a time, regardless of browser.

window.performance = window.performance or {}
performance.now = ->
    return performance.now    or
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

    reset: ->
        @start = performance.now()

    getTime: ->
        performance.now() - @start

    getAbsoluteTime: ->
        new Date().getTime()

    setStartTime: (time) ->
        @start = Number(time)

module.exports =
    Clock: Clock