class ss.ViewHelpers.MethodChain
  list_class: "ss-list"
  draw_value: (val) ->
    if _.isArray val
      return this.draw_array val
    else if _.isObject val
      return this.draw_object val
    else
      cls = "ss-value"
      if _.isString val
        cls += " ss-value-string"
        val = "\"#{val}\""
      else if _.isNumber val
        cls += " ss-value-number"
      else if _.isBoolean val
        cls += " ss-value-boolean"
      return "<li><span class=\"ss-method-argument-value #{cls}\">#{val}</span></li>"
  draw_array: (arr) ->
    html = "<ul class=\"#{@list_class} ss-method-argument-array\">"
    _.each arr, (v,i) =>
      html += this.draw_value v
    html += "</ul>"
    return html
  draw_object: (obj) ->
    html = "<dl class=\"#{@list_class} ss-method-argument-object\">"
    _.each obj, (v,k) =>
      html += "<dt class=\"ss-method-argument-object-key\">#{k}</dt>"
      html += "<dd class=\"ss-method-argument-object-value\">#{this.draw_value v}</dd>"
    html += "</dl>"
    return html