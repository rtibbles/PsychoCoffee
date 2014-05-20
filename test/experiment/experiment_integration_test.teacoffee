test "/experiment/1", ->
    visit("/experiment/1")
    andThen ->
        equal find("h2").text(), "Stroop", "Experiment header is rendered"
