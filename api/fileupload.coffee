fs = require 'fs'
dataconfig = require './dataconfig'
uuid = require 'node-uuid'
mkdirp = require 'mkdirp'
auth = require './auth'

fileUploadHandler = (request, reply) ->
    data = request.payload
    if data.file
        name = data.file.hapi.filename
        file_id = uuid.v1().split("-").join("/") +
            "." + name.split('.').pop()
        mkdirp dataconfig.filestore.root +
            "/" + file_id.split("/").slice(0, -1).join("/"),
            (err, made) ->
                if err
                    reply err
                else if made
                    path = dataconfig.filestore.root + "/" + file_id
                    file = fs.createWriteStream path

                    file.on 'error', (err) ->
                        console.error(err) 

                    data.file.pipe(file)

                    data.file.on 'end', (err) ->
                        ret =
                            name: name
                            file_id: file_id
                            headers: data.file.hapi.headers
                        reply(ret)
                else
                    reply error: "Sorry, nothing happened."

module.exports = fileUpload = (server) ->

    config = auth.config(fileUploadHandler, 'required')

    config.payload = 
        output: 'stream'
        parse: true
        allow: 'multipart/form-data'

    server.route
        method: 'POST'
        path: '/files'
        config: config
