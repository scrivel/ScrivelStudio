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

  scriptRepresentation: ->
    script = ""
    switch this.get("type")
      when "normal"
        script += this.get("target") + "."
      when "character"
        script += "{\"#{this.get("target")}\"}."
    _.each this.get("methods"), (method) ->
      args = JSON.stringify(method.arguments)
      args = args.substr(1,args.length-2)
      script += "#{method.name}(#{args})."
    script = script.substr 0, script.length-1
    script += ";"
    return script
  viewHelper: new ss.ViewHelpers.MethodChain

  parse: (response, options) ->
    response
