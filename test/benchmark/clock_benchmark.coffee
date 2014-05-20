# Benchmarking script to be run in PhantomJS

Clock = require("../../app/utils/clock")
fs = require("fs")
page = require('webpage').create()
url = "http://localhost:3333"
start_time = new Date().getTime()
stream = fs.open("./clock_benchmark" + start_time, 'w')
page.open url, ->
    window.performance = window.performance or {}
    performance.now =
            performance.now    or
            performance.mozNow    or
            performance.msNow     or
            performance.oNow      or
            performance.webkitNow or
            -> return new Date().getTime()
    clock = new Clock.Clock()
    count = 0
    test = 0
    delay = 0
    tests = 
        single_exp: [1, 2]
        single_bal: [1, 1]
        # double_exp: [2, 2]
        # double_bal: [2, 1]
        # triple_exp: [3, 2]
        # triple_bal: [3, 1]
    delays =
        0: 10
        1: 20
        2: 50
        3: 100
        4: 250
        5: 500
        6: 1000
        7: 2000
        8: 3000
        9: 5000
    behaviour = (power, callback) ->
        if count > 10
            for id in clock.delayCache
                clock.clearEvent(clock.delayCache[id])
            test += 1
            if test < Object.keys(tests).length
                return initialize()
            else
                return finalize()
        delay = delays[count % 10]
        test_name = Object.keys(tests)[test]
        start = performance.now()
        clock.delayedTrigger((-> callback(test_name, delay, start)), delay, power)
        count += 1
    report = (test_name, delay, start) ->
        stream.write test_name + " , " + delay + " , " + ((performance.now() - start) - delay) + "\n"
        behaviour(tests[test_name][1], report)
    initialize = ->
        console.log "Initializing", test
        count = 0
        val = tests[Object.keys(tests)[test]]
        for i in [0...val[0]]
            behaviour(val[1], report)
    finalize = ->
        stream.close()
        phantom.exit()
    initialize()


    
