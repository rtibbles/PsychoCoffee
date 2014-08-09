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

module.exports =
    seeded_shuffle: seeded_shuffle