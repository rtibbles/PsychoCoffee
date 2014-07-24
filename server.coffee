express = require 'express'
path = require('path')
morgan = require('morgan')
bodyParser = require('body-parser')
methodOverride = require('method-override')
api = require './api/api'

app = express()

app.use(express.static __dirname+'/public')
app.use(morgan())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use(methodOverride())
 
exports.startServer = (port, path, callback) ->
    app.get '/', (req, res) -> res.sendfile './public/index.html'

    api app

    app.listen port