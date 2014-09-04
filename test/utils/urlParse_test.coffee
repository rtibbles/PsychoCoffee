module "urlParse Util Tests",

    setup: ->

test "Method Test", ->
    expect 3

    base_url = "http://psyc.io.coffee/awesome_experiment?"

    params =
        testing: "trying_this"
        not_testing: "is_this_working"

    params_special_chars =
        "testing;this": "not"
        "testing+this": "no"
        testing: "not+this"
        test: "not;that"

    params_string = ""
    for key, value of params
        params_string+= key + "=" + value + "&"
    params_string = params_string.slice 0, -1

    deepEqual PsychoCoffee.urlParse.decodeGetParams(base_url + params_string), PsychoCoffee.urlParse.decodeGetParams(base_url + $.param(params)), "decode jQuery and manually crafted getParams"
    deepEqual PsychoCoffee.urlParse.decodeGetParams(base_url + decodeURIComponent($.param(params))), params, "jQuery encoded and params"
    deepEqual PsychoCoffee.urlParse.decodeGetParams(base_url + decodeURIComponent($.param(params_special_chars))), params_special_chars, "jQuery encoded and params with special chars"