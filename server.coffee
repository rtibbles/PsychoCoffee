express = require 'express'
mongoose = require('mongoose')
mongoskin = require('mongoskin')
path = require('path')
morgan = require('morgan')
bodyParser = require('body-parser')
methodOverride = require('method-override')

app = express()

app.use(express.static __dirname+'/public')
app.use(morgan())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use(methodOverride())
 
# mongoose.set('debug', true)
# mongoose.connect('mongodb://127.0.0.1/apitest')
 
db = mongoskin.db('mongodb://@localhost:27017/apitest', {safe:true})

exports.startServer = (port, path, callback) ->
    app.get '/', (req, res) -> res.sendfile './public/index.html'

    app.param 'collectionName', (req, res, next, collectionName) ->
        req.collection = db.collection(collectionName)
        return next()

    app.get '/api/:collectionName', (req, res, next) ->
        req.collection.find({} ,{limit:10, sort: [['_id',-1]]}).toArray (e, results) ->
            if e then return next e
            res.send results

    app.post '/api/:collectionName', (req, res, next) ->
        req.collection.insert req.body, {}, (e, results) ->
            if e then return next(e)
            res.send results

    app.listen port