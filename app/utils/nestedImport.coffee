module.exports = (folder) ->
    window.require.list().filter (module) ->
        return new RegExp('^' + folder + '/').test module
    .forEach (module) ->
        require module