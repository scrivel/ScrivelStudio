class ss.ViewHelpers.MethodChain
  draw_value: (val) ->
    if _.isArray val
      return this.draw_array val
    else if _.isObject val
      return this.draw_object val
    else
      return "<li>#{val}</li>"
  draw_array: (arr) ->
    html = "<ul>"
    _.each arr, (v,i) =>
      html += this.draw_value v
    html += "</ul>"
    return html
  draw_object: (obj) ->
    html = "<dl>"
    _.each obj, (v,k) =>
      html += "<dt>#{k}</dt>"
      html += "<dd>#{this.draw_value v}</dd>"
    html += "</dl>"
    return html