'use strict'

View = require './View'

module.exports = class HandlerView extends View

    logEvent: (event_type, options={}) =>
        @datamodel.logEvent(
            event_type
            @clock
            _.extend options,
                object: @model.name()
                )