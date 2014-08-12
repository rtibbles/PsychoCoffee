diff = (master, update) ->
    if not master then return update
    ret = {}
    for name,value of master
        if name of update
            if _.isObject(update[name])
                if _.isArray(update[name])
                    ret[name] = []
                    for i in [0...update[name].length]
                        array_diff = diff(master[name][i]?, update[name][i])
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

module.exports =
    Diff: diff