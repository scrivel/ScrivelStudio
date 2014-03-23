'use strict';

class ScrivelStudio.Models.MethodChain extends ScrivelStudio.Models.Element

  initialize: () ->

  defaults: {
    "methods" : []
    "type" : "normal"
    "target" : "app"
  }

  validate: (attrs, options) ->

  parse: (response, options) ->
    response
