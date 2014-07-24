mongoskin = require 'mongoskin'
fs = require 'fs'

db = mongoskin.db('mongodb://@localhost:27017/apitest', {safe:true})

validCollections = fs.readdirSync(__dirname + "/../app/models/").map (modelFile) -> modelFile.split(".")[0].toLowerCase()

module.exports = (app) ->
    app.param 'collectionName', (req, res, next, collectionName) ->
        if collectionName in validCollections
            req.collection = db.collection(collectionName)
            next()
        else
            res.send 404, 'Sorry, the collection you are looking for does not exist - please try again.'

    app.get '/api/:collectionName', (req, res, next) ->
        req.collection.find({} ,{limit:10, sort: [['_id',-1]]}).toArray (e, results) ->
            if e then return next e
            res.send results

    app.post '/api/:collectionName', (req, res, next) ->
        req.collection.insert req.body, {}, (e, results) ->
            if e then return next(e)
            res.send results