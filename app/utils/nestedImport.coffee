module.exports = (folder) ->
    modulesExported = []
    window.require.list().filter (module) ->
        return new RegExp('^' + folder + '/').test module
    .forEach (module) ->
        modulesExported.push module.split("/").slice(-1)
        require module
    return modulesExported