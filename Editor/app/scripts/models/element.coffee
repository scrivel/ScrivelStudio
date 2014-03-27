'use strict';

class ss.Models.Element extends Backbone.Model

  initialize: (obj) ->
    @uuid = @createUUID()
  createUUID: ->
    return this.get("range_of_lines").location + "-" + this.get("range_of_lines").length + "-" + Math.floor(Math.random()*1000).toString()
  defaults: {
    "range_of_lines" :
      location : -1
      length : 0
  }
  validate: (attrs, options) ->

  parse: (response, options) ->
    response
