'use strict';

class ScrivelStudio.Models.Element extends Backbone.Model

  initialize: () ->

  defaults: {
    "range_of_lines" :
      location : -1
      length : 0
  }
  validate: (attrs, options) ->

  parse: (response, options) ->
    response
