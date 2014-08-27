decodeGetParams = (url) ->
    url = url.split("?")
    params = {}
    for item in decodeURIComponent(url).split("&")
        data = item.split("=")
        params[data[0]] = data[1]
    return params

module.exports =
    decodeGetParams: decodeGetParams