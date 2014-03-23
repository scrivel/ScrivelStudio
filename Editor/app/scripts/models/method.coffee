'use strict';

class ScrivelStudio.Models.Method extends Backbone.Model

  initialize: () ->

  defaults: {
    "name" : ""
    "arguments" : []
    "target" : null,
    "line_number" : -1
  }

  validate: (attrs, options) ->

  parse: (response, options) ->
    response
