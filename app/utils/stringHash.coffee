define ->
    (string) ->
        hash = 5381
        if string.length == 0 then return hash
        for i in [0...string.length]
            chr   = string.charCodeAt(i)
            hash  = ((hash << 5) + hash) + chr
            hash |= 0
        return hash.toString(16)
