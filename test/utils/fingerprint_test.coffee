module "Fingerprint Util Tests",

    setup: ->

test "Method Tests", ->
    expect 2

    fingerprint = PsychoCoffee.fingerprint()

    ok typeof(fingerprint) == "string"

    repeat_fingerprint = PsychoCoffee.fingerprint()

    equal fingerprint, repeat_fingerprint
