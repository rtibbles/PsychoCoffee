define ->

    decodeGetParams = (url) ->
        url = decodeURIComponent(url).split("?")[1]
        params = {}
        if url
            for item in url.split("&")
                data = item.split("=")
                if data[1]
                    params[data[0]] = data[1]
        return params

    decodeGetParams: decodeGetParams