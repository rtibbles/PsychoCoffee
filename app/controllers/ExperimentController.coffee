'use strict'

clock = require("utils/clock")

module.exports = App.ExperimentController = Ember.ObjectController.extend
    init: ->
        @._super()
        @set 'clock', new clock.Clock()
        @refreshTime()
        @benchmark()
    refreshTime: ->
        @set 'time', @clock.getTime()
    benchmark: ->
        clock = @clock
        count = 0
        test = 0
        delay = 0
        tests = 
            single_exp: [1, 2]
            single_bal: [1, 1]
            double_exp: [2, 2]
            double_bal: [2, 1]
            triple_exp: [3, 2]
            triple_bal: [3, 1]
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
                    console.log "TERMINATION"
                    return null
            delay = delays[count % 10]
            test_name = Object.keys(tests)[test]
            clock.delayedTrigger(((diff) -> callback(test_name, delay, diff)), delay, power)
            count += 1
        report = (test_name, delay, diff) ->
            console.log test_name + " , " + delay + " , " + diff
            behaviour(tests[test_name][1], report)
        initialize = ->
            count = 0
            val = tests[Object.keys(tests)[test]]
            for i in [0...val[0]]
                behaviour(val[1], report)
        initialize()