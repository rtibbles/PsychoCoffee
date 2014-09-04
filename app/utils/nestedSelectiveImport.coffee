module.exports = (folder, moduleSubKey) ->
    subModules = {}
    window.require.list().filter (module) ->
        return new RegExp('^' + folder + '/').test module
    .forEach (module) ->
        subModules[module.split("/").slice(-1)[0]] =
            require(module)[moduleSubKey]
        if not subModules[module.split("/").slice(-1)[0]]
            delete subModules[module.split("/").slice(-1)[0]]
    return subModules