'use strict';

class ss.Models.MethodChain extends ss.Models.Element

  initialize: (obj) ->
    super obj
  defaults: {
    "methods" : []
    "type" : "normal"
    "target" : "app"
  }
  validate: (attrs, options) ->

  view_helper: new ss.ViewHelpers.MethodChain

  parse: (response, options) ->
    response
