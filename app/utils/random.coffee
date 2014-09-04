seeded_shuffle = (source_array, seed) ->
    random = new Math.seedrandom seed
    array = source_array.slice 0
    m = array.length

    # While there remain elements to shuffle…
    while m

        # Pick a remaining element…
        i = Math.floor(random() * m--)

        # And swap it with the current element.
        t = array[m]
        array[m] = array[i]
        array[i] = t

    return array

guid = (seed=null) ->
    random = seed or Math.random
    _p8 = (s) ->
        p = (random().toString(16)+"000000000").substr(2,8)
        return if s then "-" + p.substr(0,4) + "-" + p.substr(4,4) else p
    return _p8() + _p8(true) + _p8(true) + _p8()

seededguid = ->
    guid(PsychoCoffee.random.GUIDseed)

GUIDseed = null

seedGUID = (seed) ->
    PsychoCoffee.random.GUIDseed = new Math.seedrandom seed

module.exports =
    seeded_shuffle: seeded_shuffle
    guid: guid
    seededguid: seededguid
    seedGUID: seedGUID
    GUIDseed: GUIDseed