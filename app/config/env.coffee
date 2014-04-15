'use strict'

generateEnv = =>
  envObject = {}
  moduleNames = window.require.list().filter (module) ->
    return new RegExp('^envs/').test(module)

  moduleNames.forEach (module) ->
    key = module.split('/').reverse()[0]
    envObject[key] = require(module)


  return envObject

module.exports = generateEnv()