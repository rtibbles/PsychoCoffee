module "Diff Util Tests",

    setup: =>

test "Diff Method Top Level", ->
    expect 2

    test_update =
        id: "764"
        that: "this"
        this: "that"
    test_master =
        id: "764"
        that: "this"
    test_result =
        id: "764"
        this: "that"

    deepEqual PsychoCoffee.diff.Diff({}, test_update), test_update
    deepEqual PsychoCoffee.diff.Diff(test_master, test_update), test_result

test "Diff Method Nested Object", ->
    expect 1

    test_update_object =
        id: "764"
        that:
            this: "that"
            that: "this"
    test_master_object =
        id: "764"
        that:
            this: "that"

    test_result_object =
        id: "764"
        that:
            that: "this"

    deepEqual PsychoCoffee.diff.Diff(test_master_object, test_update_object), test_result_object

test "Diff Method Nested Array", ->
    expect 1

    test_update_array =
        id: "764"
        that: ["that", "this"]
    test_master_array =
        id: "764"
        that: ["that"]

    test_result_array =
        id: "764"
        that: ["that", "this"]

    deepEqual PsychoCoffee.diff.Diff(test_master_array, test_update_array), test_result_array

test "Diff Method Nested Array with Object", ->
    expect 1

    test_update_array =
        id: "764"
        that: ["that", {this: "other", that: "this"}]
    test_master_array =
        id: "764"
        that: ["that", {this: "other"}]

    test_result_array =
        id: "764"
        that: ["that", {that: "this"}]

    deepEqual PsychoCoffee.diff.Diff(test_master_array, test_update_array), test_result_array