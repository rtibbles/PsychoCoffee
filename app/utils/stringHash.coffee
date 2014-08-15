module.exports = stringHash = (string) ->
    hash = 0
    if string.length == 0 then return hash
    for i in [0...string.length]
        chr   = string.charCodeAt(i)
        hash  = ((hash << 5) - hash) + chr
        hash |= 0
    return hash
