'use strict'

clock = require("utils/clock")

module.exports = class ExperimentView extends Backbone.View
    init: ->
        @_super()
        @set 'clock', new clock.Clock()
        @refreshTime()
        # @benchmark()
    actions:
        huron: ->
            console.log @get("model.trials")
            # for model in @trialsController
            #     console.log model
    refreshTime: ->
        @set 'time', @clock.getTime()
    benchmark: ->
        clock = @clock
        count = 0
        test = 0
        delay = 0
        tests = 
            single_emb: [1, "emb"]
            single_bal: [1, "bal"]
            double_exp: [2, "emb"]
            double_bal: [2, "bal"]
            triple_exp: [3, "emb"]
            triple_bal: [3, "bal"]
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
        behaviour = (delay_func, callback) ->
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
            clock.delayedTrigger(((diff) -> callback(test_name, delay, diff)), delay, delay_func)
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