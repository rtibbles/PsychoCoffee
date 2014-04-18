'use strict'

module.exports = App.Experiment = DS.Model.extend
  title: DS.attr('string')


# Dummy data for testing
App.Experiment.FIXTURES = [
    {
     id: 1
     title: 'Stroop'
    },
    {
     id: 2
     title: '2AFC'
    },
    {
     id: 3
     title: 'Other'
    }
]