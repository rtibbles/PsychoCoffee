# Benchmarking script to be run in PhantomJS

fs = require("fs")
page = require('webpage').create()
url = "http://localhost:3333/experiment/1"
start_time = new Date().getTime()
stream = fs.open("./clock_benchmark" + start_time, 'w')
page.open url, ->
    finalize = ->
        stream.close()
        phantom.exit()
    page.onConsoleMessage = (msg) ->
        if msg=="TERMINATION"
            finalize()
        else
            stream.write msg + "\n"