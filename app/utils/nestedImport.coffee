define ->
    (folder, app) ->
        window.require.list().filter (module) ->
            return new RegExp('^' + folder + '/').test module
        .forEach (module) ->
            app[module.split("/").slice(-1)[0]] = require module