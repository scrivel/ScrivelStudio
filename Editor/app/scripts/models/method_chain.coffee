'use strict';

class ss.Models.MethodChain extends ss.Models.Element

  initialize: () ->

  defaults: {
    "methods" : []
    "type" : "normal"
    "target" : "app"
  }

  validate: (attrs, options) ->

  parse: (response, options) ->
    response
