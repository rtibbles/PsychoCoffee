module "hashObject Util Tests",

    setup: ->

test "Method Tests", ->
    expect 5

    test_object_1 =
        test: "this is a test"
        more_test: [
            "this is still a test"
            "this too"
        ]
        even_more_test: [
            so_now: "more test"
            and_now: "less test"
            also: 76213
        ]

    test_object_1_hash = 'cf2d743454b24a6bf477fe8084b41f78'

    test_object_2 =
        test: "this is not a test"
        more_test: [
            "this is still not a test"
            "this is"
        ]
        even_less_test: [
            so_now: "less test"
            and_now: "more test"
            also: 71326
        ]

    test_object_2_hash = 'ec7393d6619ecc2debaa713dc336e818'

    md5_1 = PsychoCoffee.hashObject(test_object_1)

    ok typeof(md5_1) == "string"

    equal md5_1, test_object_1_hash

    md5_1_repeat = PsychoCoffee.hashObject(test_object_1)

    equal md5_1, md5_1_repeat

    md5_2 = PsychoCoffee.hashObject(test_object_2)

    equal md5_2, test_object_2_hash

    notEqual md5_1, md5_2
