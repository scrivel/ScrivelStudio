'use strict';

class ss.Models.Words extends ScrivelStudio.Models.Element

  initialize: (obj) ->
    super obj

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
