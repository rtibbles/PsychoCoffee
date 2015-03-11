fs = require 'fs'
dataconfig = require './dataconfig'
md5 = require 'MD5'
mkdirp = require 'mkdirp'
auth = require './auth'

fileUploadHandler = (request, reply) ->
    data = request.payload
    if data.file
        name = data.file.hapi.filename
        file_md5 = md5(data.file)
        file_id = [
            file_md5.slice(0,8)
            file_md5.slice(8,12)
            file_md5.slice(12,16)
            file_md5.slice(16,20)
            file_md5.slice(20)
        ].join("/")
        mkdirp dataconfig.filestore.root +
            "/" + file_id.split("/").slice(0, -1).join("/")
        ,
            (err, made) ->
                if err
                    reply err
                else
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
