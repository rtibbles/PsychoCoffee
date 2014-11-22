module "stringHash Util Tests",

    setup: ->

test "Method Test", ->
    expect 2

    string_1 = "I am a string of arbitrary characters!"

    string_2 = "I am a seed! 2"

    equal PsychoCoffee.stringHash(string_1), PsychoCoffee.stringHash(string_1)
    notEqual PsychoCoffee.stringHash(string_1),
        PsychoCoffee.stringHash(string_2)