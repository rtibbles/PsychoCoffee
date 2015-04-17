fs = require 'fs'
dataconfig = require './dataconfig'
md5 = require 'MD5'
mkdirp = require 'mkdirp'
auth = require './auth'

fileUploadHandler = (request, reply) ->
    data = request.payload
    if data.file
        name = data.file.hapi.filename
        extension = name.split(".").slice(-1)
        path = "#{dataconfig.filestore.root}/#{name}"
        tempfile = fs.createWriteStream path

        tempfile.on 'error', (err) ->
            console.error(err)

        tempfile.on 'open', (fd) ->

            data.file.pipe(tempfile)

            data.file.on 'end', (err) ->

                tempfile.end()

                readfile = fs.readFile path, (err, buf) ->

                    file_md5 = md5(buf)
                    file_id = [
                        file_md5.slice(0,8)
                        file_md5.slice(8,12)
                        file_md5.slice(12,16)
                        file_md5.slice(16,20)
                        file_md5.slice(20)
                    ].join("/") + "." + extension
                    mkdirp dataconfig.filestore.root +
                        "/" + file_id.split("/").slice(0, -1).join("/")
                    ,
                        (err, made) ->
                            if err
                                reply err
                            else
                                new_path =
                                    "#{dataconfig.filestore.root}/#{file_id}"
                                fs.rename path, new_path, ->
                                    ret =
                                        name: name
                                        extension: extension
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
