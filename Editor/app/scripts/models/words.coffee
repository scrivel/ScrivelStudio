'use strict';

class ss.Models.Words extends ScrivelStudio.Models.Element

  initialize: () ->

  defaults: {
    "character" : null
    "arguments" : [
      "",
      {}
    ]
  }

  validate: (attrs, options) ->

  parse: (response, options) ->
    response
