'use strict';

class ScrivelStudio.Models.Words extends ScrivelStudio.Models.Element

  initialize: () ->

  defaults: {
    "character" : "undefined"
    "arguments" : [
      "",
      {}
    ]
  }

  validate: (attrs, options) ->

  parse: (response, options) ->
    response
