module "random Utils Tests",

    setup: ->

test "seeded shuffle Test", ->
    expect 2

    test_array = [0..10]

    seed_1 = "I am a seed! 1"

    seed_2 = "I am a seed! 2"

    deepEqual PsychoCoffee.random.seeded_shuffle(test_array, seed_1), PsychoCoffee.random.seeded_shuffle(test_array, seed_1)
    notDeepEqual PsychoCoffee.random.seeded_shuffle(test_array, seed_1), PsychoCoffee.random.seeded_shuffle(test_array, seed_2)

test "seeded GUID Test", ->
    expect 4

    seed = "I am a seed!"

    PsychoCoffee.random.seedGUID(seed)

    ok PsychoCoffee.random.GUIDseed?, "GUIDseed seeded"

    guid_1 = PsychoCoffee.random.seededguid()

    guid_2 = PsychoCoffee.random.seededguid()    

    notEqual guid_1, guid_2, "Unique GUIDs"

    PsychoCoffee.random.seedGUID(seed)

    equal PsychoCoffee.random.seededguid(), guid_1, "Deterministic GUID generation"
    equal PsychoCoffee.random.seededguid(), guid_2, "Deterministic GUID generation"