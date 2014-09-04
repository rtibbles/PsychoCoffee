module "key Utils Tests",

    setup: ->

test "delete Test", ->
    expect 2

    test_string = "this or that"

    result_string = "this or tha"

    equal PsychoCoffee.keys.KeysToText["delete"](test_string), result_string
    equal PsychoCoffee.keys.KeysToText["backspace"](test_string), result_string