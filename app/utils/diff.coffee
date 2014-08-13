if typeof(window) == 'undefined'
    _ = require "underscore"
else
    _ = window._

diff = (master, update) ->
    if not master then return update
    ret = {}
    for name,value of master
        if name of update
            if _.isObject(update[name])
                if _.isArray(update[name])
                    ret[name] = []
                    for i in [0...update[name].length]
                        array_diff = diff(master[name][i], update[name][i])
                        if not _.isEmpty(array_diff)
                            ret[name].push(array_diff)
                    if ret[name].length == 0 then delete ret[name]
                else
                    diff = diff(master[name], update[name])
                    if not _.isEmpty(diff)
                        ret[name] = diff
            else if not _.isEqual(master[name], update[name])
                ret[name] = update[name]
    return ret

merge = (master, update) ->
    if not master then return update
    for name, value of update
        if name of master
            if _.isObject(update[name])
                if _.isArray(update[name])
                    for i in [0...update[name].length]
                        update_node = update[name][i]
                        if _.isObject(update_node)
                            master_node = _.find(master[name], (item) ->
                                item.id==update_node.id)
                            if master_node
                                master_node = merge(master_node, update_node)
                            else
                                master[name].push update_node
                        else
                            master[name].push update_node
                else
                    master[name] = merge(master[name], update[name])
            else
                console.log name, master[name], update[name]
                master[name] = update[name]
        else
            master[name] = update[name]
    return master


module.exports =
    Diff: diff
    Merge: merge